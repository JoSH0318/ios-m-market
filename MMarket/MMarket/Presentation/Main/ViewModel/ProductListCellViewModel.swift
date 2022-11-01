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
    var bargainPrice: String { get }
    var price: String { get }
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
        return formattedString(from: product.stock)
    }

    var bargainPrice: String {
        return formattedString(from: product.bargainPrice)
    }

    var price: String {
        return formattedString(from: product.price)
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
        
        guard let numberString = formatter.string(from: number as NSNumber) else { return "" }
        
        let currency = product.currency == "KRW" ? "￦" : "$"
            
        return "\(currency) \(numberString)"
    }
    
    private func formattedString(from number: Int) -> String {
        return ""
    }
}
