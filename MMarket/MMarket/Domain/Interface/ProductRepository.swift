//
//  ProductRepository.swift
//  MMarket
//
//  Created by 조성훈 on 2022/09/22.
//

import Foundation
import RxSwift

protocol ProductRepository {
    func fetchAll(pageNumber: Int, itemsPerPage: Int) -> Observable<[Product]>
    func fetchProduct(productId: Int) -> Observable<Product>
    func createProduct(productRequest: ProductRequest, images: [ImageFile]) -> Observable<Void>
}
