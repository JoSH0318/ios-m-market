//
//  ProductUseCase.swift
//  MMarket
//
//  Created by 조성훈 on 2022/09/25.
//

import Foundation
import RxSwift

protocol ProductUseCase {
    func fetchAllProducts(pageNumber: Int, itemsPerPage: Int) -> Observable<[Product]>
    func fetchProduct(productId: Int) -> Observable<Product>
    func createProduct(productRequest: ProductRequest, images: [Data]) -> Observable<Void>
    func updateProduct(productRequest: ProductRequest, productId: Int) -> Observable<Void>
    func inquireProductSecret(password: String, productId: Int) -> Observable<String>
    func deleteProduct(secret: String, productId: Int) -> Observable<Void>
}

final class DefaultProductUseCase: ProductUseCase {
    private let repository: ProductRepository
    
    init(repository: ProductRepository) {
        self.repository = repository
    }
}

extension DefaultProductUseCase {
    func fetchAllProducts(pageNumber: Int, itemsPerPage: Int) -> Observable<[Product]> {
        return repository
            .fetchAll(pageNumber: pageNumber, itemsPerPage: itemsPerPage)
            .map { $0.map { $0.toEntity() } }
    }
    
    func fetchProduct(productId: Int) -> Observable<Product> {
        return repository
            .fetchProduct(productId: productId)
            .map { $0.toEntity() }
    }
    
    func createProduct(productRequest: ProductRequest, images: [Data]) -> Observable<Void> {
        return repository.createProduct(productRequest: productRequest, images: images)
    }
    
    func updateProduct(productRequest: ProductRequest, productId: Int) -> Observable<Void> {
        return repository.updateProduct(productRequest: productRequest, productId: productId)
    }
    
    func inquireProductSecret(password: String, productId: Int) -> Observable<String> {
        return repository
            .inquireProductSecret(password: password, productId: productId)
            .compactMap { data in
                String(data: data, encoding: .utf8)
            }
    }
    
    func deleteProduct(secret: String, productId: Int) -> Observable<Void> {
        return repository.deleteProduct(secret: secret, productId: productId)
    }
}
