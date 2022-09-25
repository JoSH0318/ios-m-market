//
//  ProductRepository.swift
//  MMarket
//
//  Created by 조성훈 on 2022/09/22.
//

import Foundation
import RxSwift

protocol ProductRepository {
    func fetchAll(pageNumber: Int, itemsPerPage: Int) -> Observable<[ProductDTO]>
    func fetchProduct(productId: Int) -> Observable<ProductDTO>
    func createProduct(productRequest: ProductRequest, images: [Data]) -> Observable<Void>
    func updateProduct(productRequest: ProductRequest, productId: Int) -> Observable<Void>
    func inquireProductSecret(password: String, productId: Int) -> Observable<Data>
    func deleteProduct(secret: String, productId: Int) -> Observable<Void>
}
