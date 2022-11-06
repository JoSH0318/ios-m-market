//
//  DetailViewModel.swift
//  MMarket
//
//  Created by 조성훈 on 2022/11/02.
//

import Foundation
import RxSwift
import RxRelay

protocol DetailViewModelInput {

}

protocol DetailViewModelOutput {
    var productDetailInfo: Observable<Product> { get }
    var productImagesURL: Observable<[String]> { get }
    var productImagesCount: Observable<Int> { get }
}

protocol DetailViewModelable: DetailViewModelInput, DetailViewModelOutput {}

final class DetailViewModel: DetailViewModelable {
    private let productUseCase: ProductUseCase
    private let disposeBag = DisposeBag()
    private let productSubject = PublishSubject<Product>()
    
    // MARK: - Output
    
    var productDetailInfo: Observable<Product> {
        return productSubject.asObservable()
    }
    
    var productImagesURL: Observable<[String]> {
        return productSubject
            .compactMap { product in
                product.images?.compactMap { $0.url }
            }
    }
    
    var productImagesCount: Observable<Int> {
        return productImagesURL
            .map { $0.count }
    }
    
    init(productUseCase: ProductUseCase, productID: Int) {
        self.productUseCase = productUseCase
        
        self.fetchProduct(by: productID)
    }
    
    // MARK: - Input
    
    func fetchProduct(by productID: Int) {
        productUseCase.fetchProduct(productId: productID)
            .withUnretained(self)
            .subscribe { viewModel, product in
                viewModel.productSubject.onNext(product)
            }
            .disposed(by: disposeBag)
    }
}
