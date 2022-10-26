//
//  ImageCacheManager.swift
//  MMarket
//
//  Created by 조성훈 on 2022/10/27.
//

import UIKit

final class ImageCacheManager {
    static let shared = ImageCacheManager()
    private let cache = NSCache<NSString, UIImage>()
    
    private init() {}
    
    func set(object: UIImage, forKey key: String) {
        cache.setObject(object, forKey: key as NSString)
    }
    
    func retrive(forKey key: String) -> UIImage? {
        cache.object(forKey: key as NSString)
    }
}
