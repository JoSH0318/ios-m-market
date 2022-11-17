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
    func didSelectImage(_ selectedImage: UIImage)
}

protocol RegisterViewModelOutput {
    var productImages: Observable<[UIImage]> { get }
    var imagesData: [Data] { get }
    var postProduct: Observable<Void> { get }
    var imagesCount: Int { get }
    var error: Observable<Error> { get }
}

protocol RegisterViewModelable: RegisterViewModelInput, RegisterViewModelOutput {}

final class RegisterViewModel: RegisterViewModelable {
    private let productUseCase: ProductUseCase
    private let disposeBag = DisposeBag()
    private let postRelay = PublishRelay<Void>()
    private let imageRelay = BehaviorRelay<[UIImage]>(value: [])
    private let errorRelay = ReplayRelay<Error>.create(bufferSize: 1)
    
    init(productUseCase: ProductUseCase) {
        self.productUseCase = productUseCase
    }
    
    // MARK: - Output
    
    var productImages: Observable<[UIImage]> {
        return imageRelay.asObservable()
    }
    
    var imagesData: [Data] {
        return convertToImageFile(from: imageRelay.value)
    }
    
    var postProduct: Observable<Void> {
        return postRelay.asObservable()
    }
    
    var imagesCount: Int {
        return imageRelay.value.count
    }
    
    var error: Observable<Error> {
        return errorRelay.asObservable()
    }
    
    // MARK: - Input
    
    func didTapPostButton(_ request: ProductRequest, images: [Data]) {
        productUseCase.createProduct(with: request, images)
            .withUnretained(self)
            .subscribe { viewModel, _ in
                
            } onError: { error in
                self.errorRelay.accept(error)
            } onCompleted: {
                self.postRelay.accept(())
            }
            .disposed(by: disposeBag)
    }
    
    func didSelectImage(_ selectedImage: UIImage) {
        var selectedImages = [UIImage]()
        selectedImages.append(selectedImage)
        imageRelay.accept(imageRelay.value + selectedImages)
    }
    
    private func convertToImageFile(from images: [UIImage]) -> [Data] {
        var imagesData = [Data]()
        images.forEach { image in
            let imageData = image.jpegData(compressionQuality: 1) ?? Data()
            imagesData.append(imageData)
        }
        return imagesData
    }
}

