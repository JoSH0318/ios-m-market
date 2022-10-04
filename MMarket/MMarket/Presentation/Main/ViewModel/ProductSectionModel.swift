//
//  ProductSectionModel.swift
//  MMarket
//
//  Created by 조성훈 on 2022/09/29.
//

import Foundation
import RxDataSources

enum ProductSectionModel {
    case eventBanner(items: [UIImage])
    case productList(items: [Product])
}

protocol ProductSectionItem {}

extension ProductSectionModel: SectionModelType {
    typealias Item = ProductSectionItem
    
    var items: [Item] {
        switch self {
        case .eventBanner(let items):
            return items
        case .productList(let items):
            return items
        }
    }
    
    init(original: ProductSectionModel, items: [ProductSectionItem]) {
        self = original
    }
}

extension Product: ProductSectionItem {}
extension UIImage: ProductSectionItem {}
