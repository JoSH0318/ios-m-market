//
//  Product.swift
//  MMarket
//
//  Created by 조성훈 on 2022/08/25.
//

import Foundation

struct Product {
    let id: Int
    let venderId: Int
    let name: String
    var description: String?
    let thumbnailURL: String
    let currency: String
    let price: Double
    let bargainPrice: Double
    let discountedPrice: Double
    let stock: Int
    var images: [ProductImage]?
    var vendor: Vendor?
    let createdAt: String
    let issuedAt: String
}
