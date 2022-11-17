//
//  UpdateImageCellModel.swift
//  MMarket
//
//  Created by 조성훈 on 2022/11/16.
//

import UIKit
import RxSwift
import RxRelay

protocol UpdateImageCellModelInput {
    func downloadImage(_ imageUrl: String)
    func didSelectedImage(_ image: UIImage)
}

protocol UpdateImageCellModelOutput {
    var productImages: Observable<UIImage> { get }
}

protocol UpdateImageCellModelable: UpdateImageCellModelInput, UpdateImageCellModelOutput {}


final class UpdateImageCellModel: UpdateImageCellModelable {
    private let imageManager = ImageManager.shared
    private let imagesRelay = BehaviorRelay<UIImage>(value: UIImage())
    
    // MARK: - Output
    
    var productImages: Observable<UIImage> {
        return imagesRelay.asObservable()
    }
    
    // MARK: - Input
    
    func downloadImage(_ imageUrl: String) {
        imageManager.downloadImage(imageUrl) { [weak self] image in
            self?.imagesRelay.accept(image)
        }
    }
    
    func didSelectedImage(_ image: UIImage) {
        imagesRelay.accept(image)
    }
}

