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
    
    func downloadImage(
        _ urlString: String,
        completion: @escaping (UIImage) -> Void
    ) -> URLSessionDataTask? {
        return downloader.downloadImage(urlString: urlString, completion: completion)
    }
    
    func set(object: UIImage, forKey key: String) {
        cache.setObject(object, forKey: key as NSString)
    }
    
    func retrieve(forKey key: String) -> UIImage? {
        cache.object(forKey: key as NSString)
    }
}
