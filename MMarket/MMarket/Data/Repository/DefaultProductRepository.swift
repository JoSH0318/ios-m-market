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
    
    func createProduct(productRequest: ProductRequest, images: [ImageFile]) -> Observable<Void> {
        let boundary = UUID().uuidString
        guard let formData = generateMultiPartForm(by: productRequest, images, boundary) else {
            return Observable.single(.error(NetworkError.invalidData))()
        }
        let endpoint = APIEndpoints.productCreation(formData, boundary).asEndpoint
        return networkProvider.execute(endpoint: endpoint)
            .map { _ in }
    }
    
    func updateProduct(productRequest: ProductRequest, productId: Int) -> Observable<Void> {
        guard let formData = generateFormData(by: productRequest) else {
            return Observable.just(Void())
        }
        let endpoint = APIEndpoints.productEdition(formData, productId).asEndpoint
        return networkProvider.execute(endpoint: endpoint)
            .map { _ in }
    }
}

extension DefaultProductRepository {
    private func generateMultiPartForm(
        by productRequest: ProductRequest,
        _ images: [ImageFile],
        _ boundary: String
    ) -> Data? {
        guard let jsonData = try? JSONEncoder().encode(productRequest) else { return nil }
        var data = Data()
        
        data.appendString("\r\n--\(boundary)\r\n")
        data.appendString("Content-Disposition: form-data; name=\"params\"\r\n")
        data.appendString("Content-Type: application/json\r\n")
        data.appendString("\r\n")
        data.append(jsonData)
        data.appendString("\r\n")
        
        for image in images {
          data.appendString("--\(boundary)\r\n")
          data.appendString("Content-Disposition: form-data; name=\"images\"; filename=\"\(image.fileName)\"\r\n")
          data.appendString("Content-Type: image/\(image.type)\r\n")
          data.appendString("\r\n")
          data.append(image.data)
          data.appendString("\r\n")
        }
        data.appendString("\r\n--\(boundary)--\r\n")
        
        return data
    }
    
    private func generateFormData(by productRequest: ProductRequest) -> Data? {
        guard let jsonData = try? JSONEncoder().encode(productRequest) else { return nil }
        var data = Data()
        data.append(jsonData)
        return data
    }
}

extension Data {
  mutating func appendString(_ string: String) {
    guard let data = string.data(using: .utf8) else {
      return
    }
    self.append(data)
  }
}
