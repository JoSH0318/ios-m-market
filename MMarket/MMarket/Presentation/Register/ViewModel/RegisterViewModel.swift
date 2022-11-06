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
}

protocol RegisterViewModelable: RegisterViewModelInput, RegisterViewModelOutput {}

final class RegisterViewModel: RegisterViewModelable {
    private let productUseCase: ProductUseCase
    private let disposeBag = DisposeBag()
    private let postSubject = PublishRelay<Void>()
    
    init(productUseCase: ProductUseCase) {
        self.productUseCase = productUseCase
    }
    
    // MARK: - Output
    
    var postProdct: Observable<Void> {
        return postSubject.asObservable()
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

