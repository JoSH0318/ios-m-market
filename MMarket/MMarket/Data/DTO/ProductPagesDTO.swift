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
        case pageNumber = "page_no"
        case itemsPerPage = "items_per_page"
        case totalCount = "total_count"
        case products = "pages"
        case lastPage = "last_page"
        case hasNext = "has_next"
        case hasPrev = "has_prev"
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
