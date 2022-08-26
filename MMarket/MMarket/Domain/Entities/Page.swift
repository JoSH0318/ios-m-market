//
//  Page.swift
//  MMarket
//
//  Created by 조성훈 on 2022/08/25.
//

import Foundation

struct Page: Decodable, Hashable {
    let uuid = UUID()
    let id: Int
    let venderId: Int
    let name: String
    let thumbnail: String
    let currency: Currency
    let price: Int
    let bargainPrice: Int
    let discountedPrice: Int
    let stock: Int
    let createdAt: String
    let issuedAt: String
    
    private enum CodingKeys: String, CodingKey {
        case id
        case venderId = "vendor_id"
        case name
        case thumbnail
        case currency
        case price
        case bargainPrice = "bargain_price"
        case discountedPrice = "discounted_price"
        case stock
        case createdAt = "created_at"
        case issuedAt = "issued_at"
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(uuid)
    }
    
    static func == (lhs: Page, rhs: Page) -> Bool {
        lhs.uuid == rhs.uuid
    }
}
