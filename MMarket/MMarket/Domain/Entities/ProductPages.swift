//
//  ProductPages.swift
//  MMarket
//
//  Created by 조성훈 on 2022/08/25.
//

import Foundation

struct ProductPages {
    let pageNumber: Int
    let itemsPerPage: Int
    let totalCount: Int
    let offset: Int
    let limit: Int
    let products: [Product]
    let lastPage: Int
    let hasNext: Bool
    let hasPrev: Bool
}
