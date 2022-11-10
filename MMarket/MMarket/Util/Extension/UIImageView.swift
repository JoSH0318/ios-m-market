//
//  UIImageView.swift
//  MMarket
//
//  Created by 조성훈 on 2022/10/31.
//

import UIKit

extension UIImageView {
    
    @discardableResult 
    func setImage(with urlString: String) -> URLSessionDataTask? {
        return ImageDownloader.shared.downloadImage(urlString: urlString) { [weak self] image in
            DispatchQueue.main.async {
                self?.image = image
            }
        }
    }
}
