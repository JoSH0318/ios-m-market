//
//  ImageManager.swift
//  MMarket
//
//  Created by 조성훈 on 2022/11/14.
//

import UIKit
import RxSwift

final class ImageManager {
    static let shared = ImageManager()
    
    private let downloader = ImageDownloader()
    private let cache: NSCache<NSString, UIImage>
    
    private init() {
        cache = NSCache()
        cache.countLimit = 350
    }
    
    func downloadImage(_ urlString: String) -> Observable<UIImage> {
        if let cachedImage = cache.object(forKey: urlString as NSString) {
            return Observable.just(cachedImage)
        }
        
        return downloader.downloadImage(urlString)
            .do { [weak self] image in
                self?.cache.setObject(image, forKey: urlString as NSString)
            }
            .asObservable()
    }
}
