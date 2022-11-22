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
    func didTapDeleteButton()
    func didTapBackButton()
    func didTapEditButton(_ product: Product)
}

protocol DetailViewModelOutput {
    var productDetailInfo: Observable<Product> { get }
    var productImagesURL: Observable<[String]> { get }
    var productImagesCount: Observable<Int> { get }
    var isPostOwner: Observable<Void> { get }
}

protocol DetailViewModelType: DetailViewModelInput, DetailViewModelOutput {}

final class DetailViewModel: DetailViewModelType {
    private let productUseCase: ProductUseCase
    private let coordinator: DetailCoordinator
    private let disposeBag = DisposeBag()
    private let productRelay = PublishRelay<Product>()
    private let productID: Int
    private(set) var product: Product?
    
    init(
        productUseCase: ProductUseCase,
        productID: Int,
        coordinator: DetailCoordinator
    ) {
        self.productUseCase = productUseCase
        self.productID = productID
        self.coordinator = coordinator
        
        self.fetchProduct(by: productID)
    }
    
    private func fetchProduct(by productID: Int) {
        productUseCase.fetchProduct(with: productID)
            .subscribe(onNext: { [weak self] product in
                self?.productRelay.accept(product)
                self?.product = product
            }, onError: { [weak self] error in
                self?.coordinator.showErrorAlert()
            })
            .disposed(by: disposeBag)
    }
    
    private func deleteProduct(with deleteURI: String) {
        productUseCase.deleteProduct(with: deleteURI)
            .observe(on: MainScheduler.instance)
            .subscribe(onError: { [weak self] error in
                self?.coordinator.showErrorAlert()
            }, onCompleted: { [weak self] in
                self?.coordinator.showAlert()
            })
            .disposed(by: disposeBag)
    }
    
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
            .filter { $0 == UserInfo.id }
            .map { _ in }
            .asObservable()
    }
    
    // MARK: - Input
    
    func didTapDeleteButton() {
        productUseCase.inquireProductSecret(with: UserInfo.password, productID)
            .subscribe(onNext: { [weak self] deleteURI in
                self?.deleteProduct(with: deleteURI)
            })
            .disposed(by: disposeBag)
    }
    
    func didTapBackButton() {
        coordinator.popDetailView()
    }
    
    func didTapEditButton(_ product: Product) {
        coordinator.showEditView(with: product)
    }
}
