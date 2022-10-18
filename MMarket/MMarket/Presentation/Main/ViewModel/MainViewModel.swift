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
    var sections: Observable<[Product]> { get }
}

protocol MainViewModelable: MainViewModelInput, MainViewModelOutput {}

final class MainViewModel {
    private let productUseCase: ProductUseCase
    private var sectionsSubject = BehaviorRelay<[Product]>(value: [])
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
            .catchAndReturn([])
    }
    
    // MARK: - Output
    
    var sections: Observable<[Product]> {
        return sectionsSubject.asObservable()
    }
}
