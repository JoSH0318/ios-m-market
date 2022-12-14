//
//  ProductRequest.swift
//  MMarket
//
//  Created by 조성훈 on 2022/09/22.
//

import Foundation

struct ProductRequest: Codable, Equatable {
    let name: String?
    let price: Int?
    let discountedPrice: Int?
    let stock: Int?
    let currency: String?
    let description: String?
    let secret: String
    
    private enum CodingKeys: String, CodingKey {
        case name, price, stock, currency, description, secret
        case discountedPrice = "discounted_price"
    }
}
