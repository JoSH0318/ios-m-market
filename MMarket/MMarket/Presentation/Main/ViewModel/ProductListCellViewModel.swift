//
//  ProductListCellViewModel.swift
//  MMarket
//
//  Created by 조성훈 on 2022/11/01.
//

import UIKit
import RxSwift
import RxRelay

final class ProductListCellViewModel {
    private let product: Product
    private let imageManager = ImageManager.shared
    private let thumbnailImageRelay = BehaviorRelay<UIImage>(value: UIImage())
    private var token: UInt
    
    // MARK: - Output

    let thumbnailImage: Observable<UIImage?>
    
    var name: String {
        return product.name
    }

    var stock: String {
        return product.stock == 0 ? "품절" : "재고 \(product.stock)"
    }
    
    var price: String {
        guard product.discountedPrice != 0 else {
            return " "
        }
        
        return formattedString(from: product.price)
    }
    
    var bargainPrice: String {
        return formattedString(from: product.bargainPrice)
    }

    var discountRate: String {
        guard product.price != product.bargainPrice else {
            return ""
        }
        
        let discountedPercent = Int((product.discountedPrice / product.price * 100).rounded())
        
        return "\(discountedPercent)%"
    }

    init(product: Product) {
        self.product = product
        self.token = imageManager.nextToken()
        
        thumbnailImage = imageManager
            .downloadImage(product.thumbnailURL, token)
            .asObservable()
    }
    
    // MARK: - Input
    
    func onPrepareForReuse() {
        imageManager.cancelTask(token)
    }
    
    private func formattedString(from number: Double) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 0
        
        guard let numberString = formatter.string(from: number as NSNumber) else {
            return ""
        }
        
        let formattedString = product.currency == "KRW" ? "\(numberString) 원" : "\(numberString) USD"
        
        return formattedString
    }
}
