//
//  ProductRequest.swift
//  MMarket
//
//  Created by 조성훈 on 2022/09/22.
//

import Foundation

struct ProductRequest: Encodable {
    let name: String
    let price: Double
    let discountedPrice: Double
    let stock: Int?
    let currency: String
    let descriptions: String?
    let secret: String
    
    private enum CodingKeys: String, CodingKey {
        case name, price, stock, currency, descriptions, secret
        case discountedPrice = "discounted_price"
    }
}
