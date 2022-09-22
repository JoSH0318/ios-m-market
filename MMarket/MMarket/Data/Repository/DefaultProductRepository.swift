//
//  DefaultProductRepository.swift
//  MMarket
//
//  Created by 조성훈 on 2022/09/23.
//

import Foundation
import RxSwift

final class DefaultProductRepository: ProductRepository {
    private let networkProvider: NetworkProvider
    
    init(networkProvider: NetworkProvider) {
        self.networkProvider = networkProvider
    }
    
    func fetchAll(pageNumber: Int, itemsPerPage: Int) -> Observable<[Product]> {
        let endpoint = APIEndpoints.productList(pageNumber, itemsPerPage).asEndpoint
        return networkProvider.execute(endpoint: endpoint)
            .decode(type: ProductPagesDTO.self, decoder: JSONDecoder())
            .map { $0.products }
            .map { $0.map { $0.toEntity() } }
    }
    
    func fetchProduct(productId: Int) -> Observable<Product> {
        let endpoint = APIEndpoints.productDetail(productId).asEndpoint
        return networkProvider.execute(endpoint: endpoint)
            .decode(type: ProductDTO.self, decoder: JSONDecoder())
            .map { $0.toEntity() }
    }
extension Data {
  mutating func appendString(_ string: String) {
    guard let data = string.data(using: .utf8) else {
      return
    }
    self.append(data)
  }
}
