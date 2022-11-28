//
//  MockProductRepository.swift
//  MMarketTests
//
//  Created by 조성훈 on 2022/11/26.
//

import Foundation
import RxSwift

@testable import MMarket

final class MockProductRepository: ProductRepository {
    private var networkProvider: NetworkProvider!
    
    var fetchProductsCallCount: Int = .zero
    var fetchProductCallCount: Int = .zero
    var createProductCallCount: Int = .zero
    var patchProductCallCount: Int = .zero
    var searchDeleteURICallCount: Int = .zero
    var deleteProductCallCount: Int = .zero
    
    init(_ networkProvider: NetworkProvider) {
        self.networkProvider = networkProvider
    }
    
    func fetchProducts(with pageNumber: Int, _ itemsPerPage: Int, _ searchValue: String) -> Observable<ProductPagesDTO> {
        fetchProductsCallCount += 1
        let endpoint = APIEndpoints
            .productList(1, 20, "test")
            .asEndpoint
        
        return networkProvider
            .execute(endpoint: endpoint)
            .decode(type: ProductPagesDTO.self, decoder: JSONDecoder())
    }
    
    func fetchProduct(with productID: Int) -> Observable<ProductDTO> {
        fetchProductCallCount += 1
        let endpoint = APIEndpoints
            .productDetail(1)
            .asEndpoint
        
        return networkProvider
            .execute(endpoint: endpoint)
            .decode(type: ProductPagesDTO.self, decoder: JSONDecoder())
            .map { $0.products.first! }
    }
    
    func createProduct(with productRequest: ProductRequest, _ images: [Data]) -> Observable<Void> {
        createProductCallCount += 1
        let data = Data()
        let boundary = "test"
        let endpoint = APIEndpoints
            .productCreation(data, boundary)
            .asEndpoint
        
        return networkProvider
            .execute(endpoint: endpoint)
            .map { _ in }
            
    }
    
    func patchProduct(with productRequest: ProductRequest, _ productID: Int) -> Observable<Void> {
        patchProductCallCount += 1
        let data = Data()
        let endpoint = APIEndpoints
            .productEdition(data, 1)
            .asEndpoint
        
        return networkProvider
            .execute(endpoint: endpoint)
            .map { _ in }
    }
    
    func searchDeleteURI(with password: String, _ productID: Int) -> Observable<Data> {
        searchDeleteURICallCount += 1
        let data = Data()
        let endpoint = APIEndpoints
            .deleteURISearch(data, 1)
            .asEndpoint
        
        return networkProvider
            .execute(endpoint: endpoint)
    }
    
    func deleteProduct(with deleteURI: String) -> Observable<Void> {
        deleteProductCallCount += 1
        let data = Data()
        let endpoint = APIEndpoints
            .deleteURISearch(data, 1)
            .asEndpoint
        
        return networkProvider
            .execute(endpoint: endpoint)
            .map { _ in }
    }
}
