//
//  ImageDownloader.swift
//  MMarket
//
//  Created by 조성훈 on 2022/10/26.
//

import Foundation
import RxSwift

final class ImageDownloader {
    static let shared = ImageDownloader()
    private let imageCacheManager = ImageCacheManager.shared
    private let session: URLSession
    private var task: URLSessionDataTask?
    
    init(session: URLSession = URLSession.shared) {
        self.session = session
    }
    
    func cancelTask() {
        task?.suspend()
        task?.cancel()
    }
    
    func requestImage(
        urlString: String,
        completion: @escaping (UIImage) -> Void
    ) {
        guard let url = URL(string: urlString) else { return }
        
        if let cacheImage = imageCacheManager.retrive(forKey: urlString) {
            completion(cacheImage)
            return
        }
        
        task = requestImageAPI(with: url) { [weak self] (result: Result<UIImage, NetworkError>) in
            switch result {
            case .success(let image):
                self?.imageCacheManager.set(object: image, forKey: urlString)
                completion(image)
            case .failure:
                guard let image = UIImage(systemName: "questionmark.square.dashed") else {
                    return
                }
                completion(image)
            }
        }
    }
    
    @discardableResult
    func requestImageAPI(
        with url: URL,
        completion: @escaping (Result<UIImage, NetworkError>) -> Void
    ) -> URLSessionDataTask? {
        return session.dataTask(with: url) { data, response, error in
            guard error == nil else {
                completion(.failure(.invaildURL))
                return
            }
            
            guard let response = response as? HTTPURLResponse,
                  (200..<300).contains(response.statusCode)
            else {
                completion(.failure(.invalidResponse))
                return
            }
            
            guard let data = data else {
                completion(.failure(.invalidData))
                return
            }
            
            guard let image = UIImage(data: data) else {
                completion(.failure(.invalidData))
                return
            }
            
            completion(.success(image))
        }
    }
}

