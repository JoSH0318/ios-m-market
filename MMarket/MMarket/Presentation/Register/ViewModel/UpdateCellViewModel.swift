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
    
    // MARK: - Output
    
    let productImage: Observable<UIImage?>
    
    init(_ imageUrl: String) {
        self.token = imageManager.nextToken()
        self.productImage = imageManager
            .downloadImage(imageUrl, token)
            .asObservable()
    }
}

final class RegisterCellViewModel: UpdateImageCellModelType  {
    
    // MARK: - Output
    
    let productImage: Observable<UIImage?>
    
    init(_ selectedImage: UIImage) {
        productImage = .just(selectedImage)
    }
}
