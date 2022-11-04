//
//  DetailViewModelItem.swift
//  MMarket
//
//  Created by 조성훈 on 2022/11/03.
//

import Foundation

struct DetailViewModelItem {
    let product: Product
    
    var thumbnailURL: String {
        return product.thumbnailURL
    }
    
    var name: String {
        return product.name
    }
    
    var bargainPrice: String {
        return formattedString(from: product.bargainPrice)
    }
    
    var price: String {
        return formattedString(from: product.price)
    }
    
    var discountRate: String {
        return calculateDiscountRate()
    }
    
    var stock: String {
        return product.stock == 0 ? "품절" : "재고수량: \(product.stock)"
    }
    
    var description: String? {
        return product.description
    }
    
    init(by product: Product) {
        self.product = product
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
    
    private func calculateDiscountRate() -> String {
        guard product.price != product.bargainPrice else {
            return ""
        }
        
        let discountedPercent = Int((product.discountedPrice / product.price * 100).rounded())
        return "\(discountedPercent)%"
    }
}
