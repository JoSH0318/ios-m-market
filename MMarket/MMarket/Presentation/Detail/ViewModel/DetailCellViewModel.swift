//
//  DetailCellViewModel.swift
//  MMarket
//
//  Created by 조성훈 on 2022/11/16.
//

import UIKit
import RxSwift
import RxRelay

protocol DetailCellViewModelInput {}

protocol DetailCellViewModelOutput {
    var productImage: Observable<UIImage> { get }
}

protocol DetailCellViewModelType: DetailCellViewModelInput, DetailCellViewModelOutput {}

final class DetailCellViewModel: DetailCellViewModelType {
    private let imageManager = ImageManager.shared
    private let imagesRelay = BehaviorRelay<UIImage>(value: UIImage())
    
    // MARK: - Output
    
    var productImage: Observable<UIImage>
    
    // MARK: - Input
    
    init(imageURL: String) {
        self.productImage = imageManager.downloadImage(imageURL)
    }
}
