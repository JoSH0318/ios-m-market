//
//  ImageManager.swift
//  MMarket
//
//  Created by 조성훈 on 2022/11/14.
//

import UIKit

final class ImageManager {
    static let shared = ImageManager()
    
    private let downloader = ImageDownloader()
    private let cache: NSCache<NSString, UIImage>
    
    private init() {
        cache = NSCache()
        cache.countLimit = 350
    }
    
    @discardableResult
    func downloadImage(
        _ urlString: String,
        completion: @escaping (UIImage) -> Void
    ) -> URLSessionDataTask? {
        if let cachedImage = cache.object(forKey: urlString as NSString) {
            completion(cachedImage)
            return nil
        }
        
        return downloader.downloadImage(urlString: urlString) { [weak self] image in
            self?.cache.setObject(image, forKey: urlString as NSString)
        }
    }
}
