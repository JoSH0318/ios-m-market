//
//  DetailProductInfo.swift
//  MMarket
//
//  Created by 조성훈 on 2022/11/03.
//

import Foundation

struct DetailProductInfo {
    let thumbnailURL: String
    let name: String
    let currency: String
    let bargainPrice: String
    let price: String
    let discountRate: String
    let stock: String
    var description: String?
    
    init(product: Product) {
        thumbnailURL = product.thumbnailURL
        name = product.name
        currency = product.currency == "KRW" ? "원" : "USD"
        bargainPrice = "\(product.bargainPrice) \(currency)"
        price = "\(product.price) \(currency)"
        stock = product.stock == 0 ? "품절" : "재고수량: \(product.stock)"
        description = product.description
        
        if product.price == product.bargainPrice {
            discountRate = ""
        } else {
            let discountedPercent = Int((product.discountedPrice / product.price * 100).rounded())
            discountRate = "\(discountedPercent)%"
        }
    }
}
