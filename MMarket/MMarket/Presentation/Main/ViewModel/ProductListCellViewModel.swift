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
    var discountRate: String { get }
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
        
        let formattedString = product.currency == "KRW" ? "\(numberString) 원" : "\(numberString) USD"
        
        return formattedString
    }
}
