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
    let thumbnail: String
    let currency: String
    let price: Int
    let bargainPrice: Int
    let discountedPrice: Int
    let stock: Int
    let images: [ProductImage]
    let vendors: Vendor
    let createdAt: String
    let issuedAt: String
}
