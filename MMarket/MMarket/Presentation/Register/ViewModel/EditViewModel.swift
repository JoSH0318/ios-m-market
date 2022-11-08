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
}

protocol EditViewModelOutput {
}

protocol EditViewModelable: EditViewModelInput, EditViewModelOutput {}

final class EditViewModel: EditViewModelable {
    private let productUseCase: ProductUseCase
    private let disposeBag = DisposeBag()
    private let patchRelay = PublishRelay<Void>()
    private let imageRelay = BehaviorRelay<[Data]>(value: [])
    private let errorRelay = ReplayRelay<Error>.create(bufferSize: 1)
    
    init(productUseCase: ProductUseCase) {
        self.productUseCase = productUseCase
    }
    
    // MARK: - Output
    
    var postProdct: Observable<Void> {
        return patchRelay.asObservable()
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
        productUseCase.createProduct(with: request, images)
            .withUnretained(self)
            .subscribe { viewModel, _ in
                
            } onError: { error in
                self.errorRelay.accept(error)
            } onCompleted: {
                self.patchRelay.accept(())
            }
            .disposed(by: disposeBag)
    }
    
    func selectImage(_ selectedImage: UIImage) {
        let imageData = convertToImageFile(from: selectedImage)
        var list = [Data]()
        imageRelay.value.forEach { list.append($0)}
        list.append(imageData)
        imageRelay.accept(list)
    }
    
    private func convertToImageFile(from image: UIImage) -> Data {
        guard let imageData = image.jpegData(compressionQuality: 1) else {
            return Data()
        }
        
        return imageData
    }
}


