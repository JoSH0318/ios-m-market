//
//  ProductSection.swift
//  MMarket
//
//  Created by 조성훈 on 2022/09/29.
//

import Foundation
import RxDataSources

enum SectionType {
    case eventBanner
    case productList
}

struct ProductSection: SectionModelType {
    typealias Item = Product
    
    var items: [Item]
    
    init(original: ProductSection, items: [Item]) {
        self = original
        self.items = items
    }
}
