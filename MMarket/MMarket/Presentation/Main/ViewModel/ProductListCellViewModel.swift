//
//  ProductListCellViewModel.swift
//  MMarket
//
//  Created by 조성훈 on 2022/11/01.
//

import Foundation

protocol ProductListCellViewModelInput {
    func prepareForReuse()
}

protocol ProductListCellViewModelOutput {
    var thumbnailURL: String { get }
    var name: String { get }
    var stock: String { get }
    var price: String { get }
    var bargainPrice: String { get }
    var discountedPercent: String { get }
    var date: String { get }
}

protocol ProductListCellViewModelable: ProductListCellViewModelInput, ProductListCellViewModelOutput {}

final class ProductListCellViewModel: ProductListCellViewModelable {
    private let product: Product

    // MARK: - Output

    var thumbnailURL: String {
        return product.thumbnailURL
    }

    var name: String {
        return product.name
    }

    var stock: String {
        guard product.stock != 0 else {
            return "품절"
        }
        
        return "재고수량 " + formattedString(from: product.stock)
    }
    
    var price: String {
        guard product.discountedPrice != 0 else {
            return ""
        }
        
        return formattedString(from: product.price)
    }
    
    var bargainPrice: String {
        return formattedString(from: product.bargainPrice)
    }

    var discountedPercent: String {
        guard product.price != product.bargainPrice else {
            return ""
        }
        
        let discountedPercent = Int((product.discountedPrice / product.price * 100).rounded())
        
        return "\(discountedPercent)%"
    }
    
    var date: String {
        return product.createdAt
    }

    init(product: Product) {
        self.product = product
    }

    // MARK: - Input
    
    func prepareForReuse() {

    }

    private func formattedString(from number: Double) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 0
        
        guard let numberString = formatter.string(from: number as NSNumber) else {
            return ""
        }
        
        let formattedString = product.currency == "KRW" ? "\(numberString) 원" : "$ \(numberString)"
        
        return formattedString
    }
    
    private func formattedString(from number: Int) -> String {
        return "\(number)"
    }
}
