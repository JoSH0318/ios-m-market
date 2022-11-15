//
//  DownloadableImageView.swift
//  MMarket
//
//  Created by 조성훈 on 2022/11/15.
//

import UIKit

final class DownloadableImageView: UIImageView {
    private let imageManager = ImageManager.shared
    private var task: URLSessionDataTask?
    
    init() {
        super.init(frame: .zero)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func cancelTask() {
        task?.suspend()
        task?.cancel()
    }
    
    func setImage(_ url: String) {
        if let cachedImage = imageManager.retrieve(forKey: url) {
            inMainScheduler {
                self.image = cachedImage
            }
        }
        
        task = imageManager.downloadImage(url) { [weak self] image in
            self?.inMainScheduler {
                self?.image = image
            }
            
            self?.imageManager.set(object: image, forKey: url)
        }
    }
    
    private func inMainScheduler(_ block: @escaping () -> ()) {
        DispatchQueue.main.async {
            block()
        }
    }
}
