//
//  ProductSectionModel.swift
//  MMarket
//
//  Created by 조성훈 on 2022/09/29.
//

import Foundation
import RxDataSources

enum ProductSectionModel {
    case eventBannerSection(items: [ProductSectionItem])
    case productListSection(items: [ProductSectionItem])
}

enum ProductSectionItem {
    case eventBannerItem(image: UIImage)
    case productListItem(product: Product)
}

extension ProductSectionModel: SectionModelType {
    typealias Item = ProductSectionItem
    
    var items: [Item] {
        switch self {
        case .eventBannerSection(let items):
            return items.map { $0 }
        case .productListSection(let items):
            return items.map { $0 }
        }
    }
    
    init(original: ProductSectionModel, items: [ProductSectionItem]) {
        switch original {
        case .eventBannerSection(items: _ ):
            self = .eventBannerSection(items: items)
        case .productListSection(items: _ ):
            self = .productListSection(items: items)
        }
    }
}
