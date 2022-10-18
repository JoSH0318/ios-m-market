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
    var products: Observable<[Product]> { get }
}

protocol MainViewModelable: MainViewModelInput, MainViewModelOutput {}

final class MainViewModel {
    private let productUseCase: ProductUseCase
    private(set) var currentPage: Int = 1
    private let disposeBag = DisposeBag()
    private var productsSubject = BehaviorRelay<[Product]>(value: [])
    
    init(productUseCase: ProductUseCase) {
        self.productUseCase = productUseCase
    }
    
    func fetchProductList(pageNumber: Int, itemsPerPage: Int = 20) {
        productUseCase
            .fetchAllProducts(pageNumber: pageNumber, itemsPerPage: itemsPerPage)
            .filter { $0.hasNext }
            .map { $0.products }
            .withUnretained(self)
            .subscribe(onNext: { vm, products in
                vm.productsSubject.accept(vm.productsSubject.value + products)
            })
            .disposed(by: disposeBag)
    }
    
    // MARK: - Output
    
    var products: Observable<[Product]> {
        return productsSubject.asObservable()
    }
}
