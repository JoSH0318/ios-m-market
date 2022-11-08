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
        fetchProducts(with: currentPage)
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
    
    func didBeginEditingSerachBar(_ text: String?) {
        fetchProducts(with: 1, 100, text)
    }
    
    func fetchProducts(with pageNumber: Int, _ itemsPerPage: Int = 20, _ searchValue: String? = "") {
        productUseCase
            .fetchProducts(with: pageNumber, itemsPerPage, searchValue)
            .filter { $0.hasNext }
            .map { $0.products }
            .withUnretained(self)
            .subscribe(onNext: { viewModel, products in
                viewModel.productsSubject.accept(products)
            })
            .disposed(by: disposeBag)
    }
}
