//
//  ProductRepository.swift
//  MMarket
//
//  Created by 조성훈 on 2022/09/22.
//

import Foundation
import RxSwift

protocol ProductRepository {
    func fetchAll(by pageNumber: Int, _ itemsPerPage: Int) -> Observable<ProductPagesDTO>
    func searchProducts(by searchValue: String) -> Observable<ProductPagesDTO>
    func fetchProduct(by productId: Int) -> Observable<ProductDTO>
    func createProduct(by productRequest: ProductRequest, _ images: [Data]) -> Observable<Void>
    func patchProduct(by productRequest: ProductRequest, _ productId: Int) -> Observable<Void>
    func inquireProductSecret(by password: String, _ productId: Int) -> Observable<Data>
    func deleteProduct(by secret: String, _ productId: Int) -> Observable<Void>
}
