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
    private let productRelay = PublishRelay<Product>()
    private let errorRelay = ReplayRelay<Error>.create(bufferSize: 1)
    private let deleteCompletionRelay = PublishRelay<Void>()
    private let productID: Int
    private(set) var product: Product?
    
    // MARK: - Output
    
    var productDetailInfo: Observable<Product> {
        return productRelay.asObservable()
    }
    
    var productImagesURL: Observable<[String]> {
        return productRelay
            .compactMap {
                $0.images?.compactMap { $0.url }
            }
    }
    
    var productImagesCount: Observable<Int> {
        return productImagesURL
            .map { $0.count }
    }
    
    var isPostOwner: Observable<Void> {
        return productRelay
            .compactMap { $0.vendor?.name }
            .filter { $0 == "mimm123" }
            .map { _ in }
            .asObservable()
    }
    
    var error: Observable<Error> {
        return errorRelay.asObservable()
    }
    
    var deleteCompletion: Observable<Void> {
        return deleteCompletionRelay.asObservable()
    }
    
    init(productUseCase: ProductUseCase, productID: Int) {
        self.productUseCase = productUseCase
        self.productID = productID
        
        self.fetchProduct(by: productID)
    }
    
    private func fetchProduct(by productID: Int) {
        productUseCase.fetchProduct(with: productID)
            .subscribe(onNext: { [weak self] product in
                self?.productRelay.accept(product)
                self?.product = product
            }, onError: { [weak self] error in
                self?.errorRelay.accept(error)
            })
            .disposed(by: disposeBag)
    }
    
    private func deleteProduct(with deleteURI: String) {
        productUseCase.deleteProduct(with: deleteURI)
            .subscribe(onError: { [weak self] error in
                self?.errorRelay.accept(error)
            }, onCompleted: { [weak self] in
                self?.deleteCompletionRelay.accept(())
            })
            .disposed(by: disposeBag)
    }
    
    // MARK: - Input
    
    func didTapDeleteButton() {
        productUseCase.inquireProductSecret(with: "xcnbof13rg2", productID)
            .subscribe(onNext: { [weak self] deleteURI in
                self?.deleteProduct(with: deleteURI)
            }, onError: { [weak self] error in
                self?.errorRelay.accept(error)
            })
            .disposed(by: disposeBag)
    }
}
