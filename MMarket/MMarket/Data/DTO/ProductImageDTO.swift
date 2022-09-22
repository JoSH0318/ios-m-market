//
//  ProductImageDTO.swift
//  MMarket
//
//  Created by 조성훈 on 2022/09/22.
//

import Foundation

struct ProductImageDTO: Decodable {
    let id: Int
    let url: String
    let thumbnailUrl: String
    let succeed: Bool
    let issuedAt: String
    
    private enum CodingKeys: String, CodingKey {
        case id, url, succeed
        case thumbnailUrl = "thumbnail_url"
        case issuedAt = "issued_at"
    }
}

extension ProductImageDTO {
    func toEntity() -> ProductImage {
        let entity = ProductImage(
            id: self.id,
            url: self.url,
            thumbnailUrl: self.thumbnailUrl,
            succeed: self.succeed,
            issuedAt: self.issuedAt
        )
        return entity
    }
}
