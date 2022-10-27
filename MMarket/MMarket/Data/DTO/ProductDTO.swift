//
//  ProductDTO.swift
//  MMarket
//
//  Created by 조성훈 on 2022/09/22.
//

import Foundation

struct ProductDTO: Decodable {
    let id: Int
    let venderId: Int
    let name: String
    var description: String?
    let thumbnail: String
    let currency: String
    let price: Int
    let bargainPrice: Int
    let discountedPrice: Int
    let stock: Int
    var images: [ProductImageDTO]?
    var vendor: VendorDTO?
    let createdAt: String
    let issuedAt: String
    
    private enum CodingKeys: String, CodingKey {
        case id, name, description, thumbnail, currency, price, stock, images
        case venderId = "vendor_id"
        case bargainPrice = "bargain_price"
        case discountedPrice = "discounted_price"
        case vendor = "vendors"
        case createdAt = "created_at"
        case issuedAt = "issued_at"
    }
}

extension ProductDTO {
    func toEntity() -> Product {
        let entity = Product(
            id: self.id,
            venderId: self.venderId ,
            name: self.name,
            description: self.description,
            thumbnail: self.thumbnail,
            currency: self.currency,
            price: self.price,
            bargainPrice: self.bargainPrice,
            discountedPrice: self.discountedPrice,
            stock: self.stock,
            images: self.images?.map{ $0.toEntity() },
            vendor: self.vendor?.toEntity(),
            createdAt: self.createdAt,
            issuedAt: self.issuedAt
        )
        
        return entity
    }
}
