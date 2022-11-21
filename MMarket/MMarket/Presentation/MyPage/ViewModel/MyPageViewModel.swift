//
//  MyPageViewModel.swift
//  MMarket
//
//  Created by 조성훈 on 2022/11/21.
//

import Foundation
import RxSwift
import RxRelay

protocol MyPageViewModelInput {
}

protocol MyPageViewModelOutput {
}

protocol MyPageViewModelType: MyPageViewModelInput, MyPageViewModelOutput {}

final class MyPageViewModel: MyPageViewModelType {
    private let productUseCase: ProductUseCase
    private let coordinator: MyPageCoordinator
    private let disposeBag = DisposeBag()
    
    init(
        productUseCase: ProductUseCase,
        coordinator: MyPageCoordinator
    ) {
        self.productUseCase = productUseCase
        self.coordinator = coordinator
        
        self.products = productUseCase.fetchProducts(with: 1, 20, UserInfo.id)
            .map { $0.products }
    }
    
    // MARK: - Output
    
    var products: Observable<[Product]>
    
    // MARK: - Input
    
    func didTapCell(_ product: Product) {
        coordinator.showDetailView(productID: product.id)
    }
}
