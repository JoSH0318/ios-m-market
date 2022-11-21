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
    func didTapBackButton()
    func didTapAddImageButton(_ picker: UIImagePickerController)
    func didTapPostButton(_ request: ProductRequest, images: [Data])
    func didSelectImage(_ selectedImage: UIImage)
}

protocol RegisterViewModelOutput {
    var productImages: Observable<[UIImage]> { get }
    var imagesData: [Data] { get }
    var imagesCount: Int { get }
}

protocol RegisterViewModelType: RegisterViewModelInput, RegisterViewModelOutput {}

final class RegisterViewModel: RegisterViewModelType {
    private let productUseCase: ProductUseCase
    private let coordinator: RegisterCoordinator
    private let disposeBag = DisposeBag()
    private let imageRelay = BehaviorRelay<[UIImage]>(value: [])
    
    
    private func convertToImageFile(from images: [UIImage]) -> [Data] {
        var imagesData = [Data]()
        images.forEach { image in
            let imageData = image.jpegData(compressionQuality: 1) ?? Data()
            imagesData.append(imageData)
        }
        return imagesData
    }
    
    init(
        productUseCase: ProductUseCase,
        coordinator: RegisterCoordinator
    ) {
        self.productUseCase = productUseCase
        self.coordinator = coordinator
    }
    
    // MARK: - Output
    
    var productImages: Observable<[UIImage]> {
        return imageRelay.asObservable()
    }
    
    var imagesData: [Data] {
        return convertToImageFile(from: imageRelay.value)
    }
    
    var imagesCount: Int {
        return imageRelay.value.count
    }
    
    // MARK: - Input
    
    func didTapBackButton() {
        coordinator.popRegisterView()
    }
    
    func didTapAddImageButton(_ picker: UIImagePickerController) {
        coordinator.showPhotoLibrary(to: picker)
    }
    
    func didTapPostButton(_ request: ProductRequest, images: [Data]) {
        productUseCase.createProduct(with: request, images)
            .observe(on: MainScheduler.instance)
            .withUnretained(self)
            .subscribe(onNext: { viewModel, _ in
                
            }, onError: { error in
                self.coordinator.showErrorAlert()
            }, onCompleted: {
                self.coordinator.showAlert(with: "제품을 등록했습니다.")
            })
            .disposed(by: disposeBag)
    }
    
    func didSelectImage(_ selectedImage: UIImage) {
        var selectedImages = [UIImage]()
        selectedImages.append(selectedImage)
        imageRelay.accept(imageRelay.value + selectedImages)
    }
}

