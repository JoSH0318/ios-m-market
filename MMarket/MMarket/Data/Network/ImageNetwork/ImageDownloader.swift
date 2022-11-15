//
//  ImageDownloader.swift
//  MMarket
//
//  Created by 조성훈 on 2022/10/26.
//

import UIKit

final class ImageDownloader {
    private let session: URLSession
    
    init(session: URLSession = URLSession.shared) {
        self.session = session
    }
    
    func downloadImage(
        urlString: String,
        completion: @escaping (UIImage) -> Void
    ) -> URLSessionDataTask? {
        guard let url = URL(string: urlString) else { return nil }
        
        let task = requestImage(with: url) { (result: Result<UIImage, NetworkError>) in
            switch result {
            case .success(let image):
                completion(image)
            case .failure:
                guard let image = UIImage(systemName: "questionmark.square.dashed") else { return }
                completion(image)
            }
        }
        
        task?.resume()
        return task
    }
    
    @discardableResult
    private func requestImage(
        with url: URL,
        completion: @escaping (Result<UIImage, NetworkError>) -> Void
    ) -> URLSessionDataTask? {
        return session.dataTask(with: url) { data, response, error in
            guard error == nil else {
                completion(.failure(.invalidURL))
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
