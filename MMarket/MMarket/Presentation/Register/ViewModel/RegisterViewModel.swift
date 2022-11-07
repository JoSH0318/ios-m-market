//
//  RegisterViewModel.swift
//  MMarket
//
//  Created by 조성훈 on 2022/11/04.
//

import Foundation
import RxSwift
import RxRelay

protocol RegisterViewModelInput {
    func didTapPostButton(_ request: ProductRequest, images: [Data])
}

protocol RegisterViewModelOutput {
    var postProdct: Observable<Void> { get }
    var productImages: [Data] { get }
}

protocol RegisterViewModelable: RegisterViewModelInput, RegisterViewModelOutput {}

final class RegisterViewModel: RegisterViewModelable {
    private let productUseCase: ProductUseCase
    private let disposeBag = DisposeBag()
    private let postRelay = PublishRelay<Void>()
    private let imageRelay = BehaviorRelay<[Data]>(value: [])
    private let errorRelay = ReplayRelay<Error>.create(bufferSize: 1)
    
    init(productUseCase: ProductUseCase) {
        self.productUseCase = productUseCase
    }
    
    // MARK: - Output
    
    var postProdct: Observable<Void> {
        return postRelay.asObservable()
    }
    
    var productImages: [Data] {
        return imageRelay.value
    }
    
    var imagesCount: Int {
        return imageRelay.value.count
    }
    
    var error: Observable<Error> {
        return errorRelay.asObservable()
    }
    
    // MARK: - Input
    
    func didTapPostButton(_ request: ProductRequest, images: [Data]) {
        productUseCase.createProduct(productRequest: request, images: images)
            .subscribe(onCompleted: { [weak self] in
                self?.postSubject.accept(())
            })
            .disposed(by: disposeBag)
    }
}

