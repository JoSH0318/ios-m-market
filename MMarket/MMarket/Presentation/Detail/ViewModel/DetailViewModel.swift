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
    private let errorRelay = ReplayRelay<Error>.create(bufferSize: 1)
    private let deleteKeyRelay = PublishRelay<String>()
    private let deleteCompletionRelay = PublishRelay<Void>()
    private let productID: Int
    
    // MARK: - Output
    
    var productDetailInfo: Observable<Product> {
        return productSubject.asObservable()
    }
    
    var productImagesURL: Observable<[String]> {
        return productSubject
            .compactMap {
                $0.images?.compactMap { $0.url }
            }
    }
    
    var productImagesCount: Observable<Int> {
        return productImagesURL
            .map { $0.count }
    }
    
    var isPostOwner: Observable<Void> {
        return productSubject
            .compactMap { product in
                product.vendor?.name
            }
            .filter { userName in
                userName == "mimm123"
            }
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
        self.deleteProduct()
    }
    
    private func fetchProduct(by productID: Int) {
        productUseCase.fetchProduct(with: productID)
            .subscribe(onNext: { [weak self] product in
                self?.productSubject.onNext(product)
            }, onError: { [weak self] error in
                self?.errorRelay.accept(error)
            })
            .disposed(by: disposeBag)
    }
    
    private func deleteProduct() {
        deleteKeyRelay
            .withUnretained(self)
            .subscribe(onNext: { viewModel, deleteKey in
                viewModel.deleteProduct(with: deleteKey)
            })
            .disposed(by: disposeBag)
    }
    
    private func deleteProduct(with deleteURI: String) {
        productUseCase.deleteProduct(with: deleteURI)
            .withUnretained(self)
            .subscribe(onNext: { viewModel, _ in
                
            }, onError: { error in
                self.errorRelay.accept(error)
            }, onCompleted: {
                self.deleteCompletionRelay.accept(())
            })
            .disposed(by: disposeBag)
    }
    
    // MARK: - Input
    
    func didTapDeleteButton() {
        productUseCase.inquireProductSecret(with: "xcnbof13rg2", productID)
            .withUnretained(self)
            .subscribe { viewModel, deleteKey in
                viewModel.deleteKeyRelay.accept(deleteKey)
            } onError: { error in
                self.errorRelay.accept(error)
            }
            .disposed(by: disposeBag)
    }
    
    
}
