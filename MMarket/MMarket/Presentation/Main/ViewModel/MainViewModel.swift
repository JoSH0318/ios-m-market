//
//  MainViewModel.swift
//  MMarket
//
//  Created by 조성훈 on 2022/09/27.
//

import Foundation
import RxSwift
import RxRelay

protocol MainViewModelInput {}

protocol MainViewModelOutput {
    var sections: Observable<[ProductSectionModel]> { get }
}

protocol MainViewModelable: MainViewModelInput, MainViewModelOutput {}

final class MainViewModel {
    private let productUseCase: ProductUseCase
    private(set) var currentPage: Int = 1
    
    init(productUseCase: ProductUseCase) {
        self.productUseCase = productUseCase
    }
    
    private func fetchProductList(pageNumber: Int, itemsPerPage: Int = 20) -> Observable<[Product]> {
        return productUseCase
            .fetchAllProducts(pageNumber: pageNumber, itemsPerPage: itemsPerPage)
            .filter { $0.hasNext }
            .do { self.currentPage = $0.pageNumber }
            .map { $0.products }
    }
    
    // MARK: - Output
    
    var sections: Observable<[ProductSectionModel]> {
        return Observable
            .combineLatest(
                Observable.just([UIImage()]),
                self.fetchProductList(pageNumber: currentPage)
            )
            .map { images, products in
                var sections: [ProductSectionModel] = []
                sections.append(.eventBanner(items: images))
                sections.append(.productList(items: products))
                
                return sections
            }
    }
}
