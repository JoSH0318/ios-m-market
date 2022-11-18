//
//  ImageDownloader.swift
//  MMarket
//
//  Created by 조성훈 on 2022/10/26.
//

import UIKit
import RxSwift

protocol ImageDownloaderType{
    func downloadImage(_ urlString: String) -> Single<UIImage>
}

final class ImageDownloader: ImageDownloaderType {
    private let session: URLSession
    
    init(session: URLSession = URLSession.shared) {
        self.session = session
    }
    
    func downloadImage(_ urlString: String) -> Single<UIImage> {
        return Single<UIImage>.create { [weak self] single in
            
            guard let url = URL(string: urlString) else {
                single(.failure(NetworkError.invalidURL))
                return Disposables.create()
            }
            
            let task = self?.session.dataTask(with: url) { data, response, error in
                
                guard error == nil else {
                    single(.failure(NetworkError.errorIsOccurred(error.debugDescription)))
                    return
                }
                
                guard let response = response as? HTTPURLResponse,
                      (200..<300).contains(response.statusCode)
                else {
                    single(.failure(NetworkError.invalidResponse))
                    return
                }
                
                guard let data = data else {
                    single(.failure(NetworkError.invalidData))
                    return
                }
                
                guard let image = UIImage(data: data) else {
                    single(.failure(NetworkError.invalidData))
                    return
                }
                
                single(.success(image))
            }
            task?.resume()
            
            return Disposables.create {
                task?.suspend()
                task?.cancel()
            }
        }
    }
}
