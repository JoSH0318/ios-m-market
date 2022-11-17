//
//  EditionViewModel.swift
//  MMarket
//
//  Created by 조성훈 on 2022/11/08.
//

import Foundation
import RxSwift
import RxRelay

protocol EditViewModelInput {
    func didLaunchView()
    func didTapSaveButton(_ request: ProductRequest)
}

protocol EditViewModelOutput {
    var imageURL: Observable<[String]> { get }
    var patchProduct: Observable<Void> { get }
    var error: Observable<Error> { get }
}

protocol EditViewModelable: EditViewModelInput, EditViewModelOutput {}

final class EditViewModel: EditViewModelable {
    private let productUseCase: ProductUseCase
    private let disposeBag = DisposeBag()
    private let patchRelay = PublishRelay<Void>()
    private let errorRelay = ReplayRelay<Error>.create(bufferSize: 1)
    private(set) var product: Product
    private let imageURLRelay = BehaviorRelay<[String]>(value: [])
    
    init(
        productUseCase: ProductUseCase,
        product: Product
    ) {
        self.productUseCase = productUseCase
        self.product = product
    }
    
    // MARK: - Output
    
    var imageURL: Observable<[String]> {
        return imageURLRelay.asObservable()
    }
    
    var patchProduct: Observable<Void> {
        return patchRelay.asObservable()
    }
    
    var error: Observable<Error> {
        return errorRelay.asObservable()
    }
    
    // MARK: - Input
    
    func didLaunchView() {
        var imageURLs = [String]()
        product.images?.forEach {
            imageURLs.append($0.url)
        }
        
        imageURLRelay.accept(imageURLs)
    }
    
    func didTapSaveButton(_ request: ProductRequest) {
        productUseCase.updateProduct(with: request, product.id)
            .subscribe(onError: { [weak self] error in
                self?.errorRelay.accept(error)
            }, onCompleted: { [weak self] in
                self?.patchRelay.accept(())
            })
            .disposed(by: disposeBag)
    }
}


