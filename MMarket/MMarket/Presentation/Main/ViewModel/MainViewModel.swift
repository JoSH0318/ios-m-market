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
    func didBeginEditingSearchBar(_ text: String)
    func didScrollToNextPage(_ row: Int)
}

protocol MainViewModelOutput {
    var products: Observable<[Product]> { get }
}

protocol MainViewModelable: MainViewModelInput, MainViewModelOutput {}

final class MainViewModel: MainViewModelable {
    private let productUseCase: ProductUseCase
    weak var coordinator: MainCoordinator?
    private var currentPageNumber: Int
    private let disposeBag = DisposeBag()
    private var productsSubject = BehaviorRelay<[Product]>(value: [])
    
    init(
        productUseCase: ProductUseCase,
        coordinator: MainCoordinator
    ) {
        self.productUseCase = productUseCase
        self.coordinator = coordinator
        self.currentPageNumber = 1
    }
    
    // MARK: - Output
    
    var products: Observable<[Product]> {
        return productsSubject.asObservable()
    }
    
    // MARK: - Input
    
    func didLaunchView() {
        currentPageNumber = 1
        productsSubject.accept([])
        fetchProducts(pageNumber: currentPageNumber)
    }
    
    func didTapCell(_ product: Product) {
        coordinator?.showDetailView(productID: product.id)
    }
    
    func didTapRegisterButton() {
        coordinator?.showRegisterView()
    }
    
    func didBeginEditingSearchBar(_ text: String) {
        fetchSearchedProducts(searchValue: text)
    }
    
    func didScrollToNextPage(_ row: Int) {
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
    
    private func fetchSearchedProducts(searchValue: String) {
        productUseCase.fetchProducts(with: 1, 20, searchValue)
            .map { $0.products }
            .withUnretained(self)
            .subscribe(onNext: { viewModel, products in
                viewModel.productsSubject.accept([])
                viewModel.productsSubject.accept(products)
            })
            .disposed(by: disposeBag)
    }
}
