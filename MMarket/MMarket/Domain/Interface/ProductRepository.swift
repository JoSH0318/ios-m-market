//
//  Repository.swift
//  MMarket
//
//  Created by 조성훈 on 2022/09/22.
//

import Foundation
import RxSwift

protocol ProductRepository {
    func fetchAll(endpoint: Endpoint) -> Observable<[PagesData]>
    func fetchProduct(endpoint: Endpoint) -> Observable<PagesData>
    func createProduct(endpoint: Endpoint) -> Observable<Void>
    func updateProduct(endpoint: Endpoint) -> Observable<Void>
    func searchSecretKey(endpoint: Endpoint)
    func deleteProduct(endpoint: Endpoint) -> Observable<Void>
}
