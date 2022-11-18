//
//  DetailViewImagesCellModel.swift
//  MMarket
//
//  Created by 조성훈 on 2022/11/16.
//

import UIKit
import RxSwift
import RxRelay

protocol DetailViewImagesCellModelInput {
}

protocol DetailViewImagesCellModelOutput {
}

protocol DetailViewImagesCellModelable: DetailViewImagesCellModelInput, DetailViewImagesCellModelOutput {}


final class DetailViewImagesCellModel: DetailViewImagesCellModelable {
    private let imageManager = ImageManager.shared
    private let imagesRelay = BehaviorRelay<UIImage>(value: UIImage())
    
    // MARK: - Output
    
    var productImage: Observable<UIImage>
    
    // MARK: - Input
    
    init(imageURL: String) {
//        imageManager.downloadImage(imageURL) { [weak self] image in
//            self?.imagesRelay.accept(image)
//        }
        self.productImage = imageManager.downloadImage(imageURL)
    }
}
