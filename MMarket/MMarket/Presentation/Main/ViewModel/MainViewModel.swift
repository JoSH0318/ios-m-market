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
    func didLaunchView()
    func didTapCell(_ product: Product)
    func didScroll(_ row: Int)
}

protocol MainViewModelOutput {
    var products: Observable<[Product]> { get }
    var showDetailView: PublishRelay<Product> { get }
}

protocol MainViewModelable: MainViewModelInput, MainViewModelOutput {}

final class MainViewModel: MainViewModelable {
    private let productUseCase: ProductUseCase
    private var currentPageNumber: Int
    private let disposeBag = DisposeBag()
    private var productsSubject = BehaviorRelay<[Product]>(value: [])
    
    init(productUseCase: ProductUseCase) {
        self.productUseCase = productUseCase
    }
    
    // MARK: - Output
    
    var products: Observable<[Product]> {
        return productsSubject.asObservable()
    }
    
    var showDetailView = PublishRelay<Product>()
    
    // MARK: - Input
    
    func didLaunchView() {
        currentPageNumber = 1
        fetchProducts(pageNumber: currentPageNumber)
    }
    
    func didTapCell(_ product: Product) {
        showDetailView.accept(product)
    }
    
    func didBeginEditingSearchBar(_ text: String) {
        fetchProducts(pageNumber: 1, searchValue: text)
    }
    
    func didScroll(_ row: Int) {
        if row == currentPageNumber * 20 - 1 {
            currentPageNumber += 1
            fetchProducts(pageNumber: currentPageNumber)
        }
    }
    
    private func fetchProducts(
        pageNumber: Int,
        itemsPerPage: Int = 20,
        searchValue: String = ""
    ) {
        productUseCase.fetchProducts(with: pageNumber, itemsPerPage, searchValue)
            .map { $0.products }
            .withUnretained(self)
            .subscribe(onNext: { viewModel, products in
                let preProducts = viewModel.productsSubject.value
                viewModel.productsSubject.accept(preProducts + products)
            })
            .disposed(by: disposeBag)
    }
}
