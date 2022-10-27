//
//  ProductPagesDTO.swift
//  MMarket
//
//  Created by 조성훈 on 2022/09/22.
//

import Foundation

struct ProductPagesDTO: Decodable {
    let pageNumber: Int
    let itemsPerPage: Int
    let totalCount: Int
    let offset: Int
    let limit: Int
    let products: [ProductDTO]
    let lastPage: Int
    let hasNext: Bool
    let hasPrev: Bool
    
    private enum CodingKeys: String, CodingKey {
        case offset, limit
        case pageNumber = "pageNo"
        case itemsPerPage = "itemsPerPage"
        case totalCount = "totalCount"
        case products = "pages"
        case lastPage = "lastPage"
        case hasNext = "hasNext"
        case hasPrev = "hasPrev"
    }
}

extension ProductPagesDTO {
    func toEntity() -> ProductPages {
        let entity = ProductPages(
            pageNumber: self.pageNumber,
            itemsPerPage: self.itemsPerPage,
            products: self.products.map { $0.toEntity() },
            hasNext: self.hasNext
        )
        
        return entity
    }
}
