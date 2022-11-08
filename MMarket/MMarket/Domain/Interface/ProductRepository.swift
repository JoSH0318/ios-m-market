//
//  ProductRepository.swift
//  MMarket
//
//  Created by 조성훈 on 2022/09/22.
//

import Foundation
import RxSwift

protocol ProductRepository {
    func fetchAll(with pageNumber: Int, _ itemsPerPage: Int) -> Observable<ProductPagesDTO>
    func searchProducts(with searchValue: String) -> Observable<ProductPagesDTO>
    func fetchProduct(with productID: Int) -> Observable<ProductDTO>
    func createProduct(with productRequest: ProductRequest, _ images: [Data]) -> Observable<Void>
    func patchProduct(with productRequest: ProductRequest, _ productID: Int) -> Observable<Void>
    func searchDeleteURI(with password: String, _ productID: Int) -> Observable<Data>
    func deleteProduct(with deleteURI: String) -> Observable<Void>
}
