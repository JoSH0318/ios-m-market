//
//  ProductUseCase.swift
//  MMarket
//
//  Created by 조성훈 on 2022/09/25.
//

import Foundation
import RxSwift

protocol ProductUseCase {
    func fetchProducts(with pageNumber: Int, _ itemsPerPage: Int, _ searchValue: String) -> Observable<ProductPages>
    func fetchProduct(with productId: Int) -> Observable<Product>
    func createProduct(with productRequest: ProductRequest, _ images: [Data]) -> Observable<Void>
    func updateProduct(with productRequest: ProductRequest, _ productID: Int) -> Observable<Void>
    func inquireProductSecret(with password: String, _ productID: Int) -> Observable<String>
    func deleteProduct(with deleteURI: String) -> Observable<Void>
}

final class DefaultProductUseCase: ProductUseCase {
    private let repository: ProductRepository
    
    init(repository: ProductRepository) {
        self.repository = repository
    }
}

extension DefaultProductUseCase {
    func fetchProducts(
        with pageNumber: Int,
        _ itemsPerPage: Int,
        _ searchValue: String
    ) -> Observable<ProductPages> {
        return repository
            .fetchProducts(with: pageNumber, itemsPerPage, searchValue)
            .map { $0.toEntity() }
    }
    
    func fetchProduct(with productID: Int) -> Observable<Product> {
        return repository
            .fetchProduct(with: productID)
            .map { $0.toEntity() }
    }
    
    func createProduct(with productRequest: ProductRequest, _ images: [Data]) -> Observable<Void> {
        return repository.createProduct(with: productRequest, images)
    }
    
    func updateProduct(with productRequest: ProductRequest, _ productID: Int) -> Observable<Void> {
        return repository.patchProduct(with: productRequest, productID)
    }
    
    func inquireProductSecret(with password: String, _ productID: Int) -> Observable<String> {
        return repository
            .searchDeleteURI(with: password, productID)
            .compactMap { data in
                String(data: data, encoding: .utf8)
            }
    }
    
    func deleteProduct(with deleteURI: String) -> Observable<Void> {
        return repository.deleteProduct(with: deleteURI)
    }
}
