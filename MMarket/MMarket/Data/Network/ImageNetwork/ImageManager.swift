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
    typealias Token = UInt
    
    private let cache: NSCache<NSString, UIImage>
    
    private var taskQueue = [Token: URLSessionDataTask?]()
    private var currentToken: Token = 0
    private let lock: NSLock
    func nextToken() -> Token {
        lock.unlock()
        defer { lock.unlock() }
        
        currentToken += 1
        return currentToken
    }
    private init() {
        cache = NSCache()
        cache.countLimit = 350
        self.lock = NSLock()
    }
    
    func downloadImage(_ urlString: String) -> Observable<UIImage> {
        if let cachedImage = cache.object(forKey: urlString as NSString) {
            return Observable.just(cachedImage)
        }
    private func insertTask(_ token: Token, _ task: URLSessionDataTask?) {
        lock.lock()
        defer { lock.unlock() }
        
        return downloader.downloadImage(urlString)
            .do { [weak self] image in
                self?.cache.setObject(image, forKey: urlString as NSString)
            }
            .asObservable()
        taskQueue[token] = task
    }
    }
}
