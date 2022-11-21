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
    func didTapBackButton()
    func didTapSaveButton(_ request: ProductRequest)
}

protocol EditViewModelOutput {
    var imageURL: Observable<[String]> { get }
}

protocol EditViewModelType: EditViewModelInput, EditViewModelOutput {}

final class EditViewModel: EditViewModelType {
    private let productUseCase: ProductUseCase
    private let coordinator: EditCoordinator
    private let disposeBag = DisposeBag()
    private(set) var product: Product
    private let imageURLRelay = BehaviorRelay<[String]>(value: [])
    
    init(
        productUseCase: ProductUseCase,
        product: Product,
        coordinator: EditCoordinator
    ) {
        self.productUseCase = productUseCase
        self.product = product
        self.coordinator = coordinator
    }
    
    // MARK: - Output
    
    var imageURL: Observable<[String]> {
        return imageURLRelay.asObservable()
    }
    
    // MARK: - Input
    
    func didLaunchView() {
        var imageURLs = [String]()
        product.images?.forEach {
            imageURLs.append($0.url)
        }
        
        imageURLRelay.accept(imageURLs)
    }
    
    func didTapBackButton() {
        coordinator.popEditView()
    }
    
    func didTapSaveButton(_ request: ProductRequest) {
        productUseCase.updateProduct(with: request, product.id)
            .observe(on: MainScheduler.instance)
            .subscribe(onError: { [weak self] error in
                self?.coordinator.showErrorAlert()
            }, onCompleted: { [weak self] in
                self?.coordinator.showAlert(with: "입력하신 내용이 저장됐습니다.")
            })
            .disposed(by: disposeBag)
    }
}


