//
//  UpdateCellViewModel.swift
//  MMarket
//
//  Created by 조성훈 on 2022/11/16.
//

import UIKit
import RxSwift
import RxRelay

protocol UpdateImageCellModelInput {}

protocol UpdateImageCellModelOutput {
    var productImage: Observable<UIImage?> { get }
}

protocol UpdateImageCellModelType: UpdateImageCellModelInput, UpdateImageCellModelOutput {}

final class EditCellViewModel: UpdateImageCellModelType {
    private let imageManager = ImageManager.shared
    private let token: UInt
    
    init(_ imageUrl: String) {
        self.token = imageManager.nextToken()
        self.productImage = imageManager
            .downloadImage(imageUrl, token)
            .asObservable()
    }
    
    // MARK: - Output
    
    let productImage: Observable<UIImage?>
}

final class RegisterCellViewModel: UpdateImageCellModelType  {
    
    init(_ selectedImage: UIImage) {
        productImage = .just(selectedImage)
    }
    
    // MARK: - Output
    
    let productImage: Observable<UIImage?>
}
