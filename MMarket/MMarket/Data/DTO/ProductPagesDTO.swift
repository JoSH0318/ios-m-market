//
//  ProductPagesDTO.swift
//  MMarket
//
//  Created by 조성훈 on 2022/09/22.
//

import Foundation

struct ProductPagesDTO: Codable, Equatable {
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
        case offset, limit, itemsPerPage, totalCount, lastPage, hasNext, hasPrev
        case pageNumber = "pageNo"
        case products = "pages"
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
