//
//  ProductListCellViewModel.swift
//  MMarket
//
//  Created by 조성훈 on 2022/11/01.
//

import Foundation
import UIKit

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
        return formattedString(by: product.stock)
    }
    
    var bargainPrice: String {
        return formattedString(by: product.bargainPrice)
    }
    
    var price: String {
        return formattedString(by: product.price)
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
    
    private func formattedString(by number: Int) -> String {
        return ""
    }
}
