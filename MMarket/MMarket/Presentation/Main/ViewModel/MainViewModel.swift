//
//  MainViewModel.swift
//  MMarket
//
//  Created by 조성훈 on 2022/09/27.
//

import Foundation
import RxSwift
import RxRelay

protocol MainViewModelInput {
    func didTapCell(_ product: Product)
}

protocol MainViewModelOutput {
    var products: Observable<[Product]> { get }
    var showDetailView: PublishRelay<Product> { get }
}

protocol MainViewModelable: MainViewModelInput, MainViewModelOutput {}

final class MainViewModel: MainViewModelable {
    private let productUseCase: ProductUseCase
    private(set) var currentPage: Int = 1
    private let disposeBag = DisposeBag()
    private var productsSubject = BehaviorRelay<[Product]>(value: [])
    
    init(productUseCase: ProductUseCase) {
        self.productUseCase = productUseCase
        fetchProductList(pageNumber: currentPage)
    }
    
    // MARK: - Output
    
    var products: Observable<[Product]> {
        return productsSubject.asObservable()
    }
    
    var showDetailView = PublishRelay<Product>()
    
    // MARK: - Input
    
    func didTapCell(_ product: Product) {
        showDetailView.accept(product)
    }
    
    func fetchProductList(pageNumber: Int, itemsPerPage: Int = 20) {
        productUseCase
            .fetchAllProducts(pageNumber: pageNumber, itemsPerPage: itemsPerPage)
            .filter { $0.hasNext }
            .map { $0.products }
            .withUnretained(self)
            .subscribe(onNext: { viewModel, products in
                viewModel.productsSubject.accept(products)
            })
            .disposed(by: disposeBag)
    }
}
