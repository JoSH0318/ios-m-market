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
    
    func createProduct(productRequest: ProductRequest, images: [Data]) -> Observable<Void> {
        let boundary = UUID().uuidString
        let formData = generateFormData(by: productRequest)
        let imageFormDatas = generateImageFormDatas(by: images)
        let body = HTTPBodyBuilder.create(uuid: boundary)
            .append(formData)
            .append(imageFormDatas)
            .apply()
        let endpoint = APIEndpoints.productCreation(body, boundary).asEndpoint
        
        return networkProvider.execute(endpoint: endpoint)
            .map { _ in }
    }
    
    func updateProduct(productRequest: ProductRequest, productId: Int) -> Observable<Void> {
        let formData = generateFormData(by: productRequest)
        let body = HTTPBodyBuilder.create()
            .append(formData)
            .apply()
        let endpoint = APIEndpoints.productEdition(body, productId).asEndpoint
        
        return networkProvider
            .execute(endpoint: endpoint)
            .map { _ in }
    }
    
    func inquireProductSecret(password: String, productId: Int) -> Observable<Data> {
        let body = HTTPBodyBuilder.create()
            .append(password)
            .apply()
        let endpoint = APIEndpoints.scretKeySearch(body, productId).asEndpoint
        
        return networkProvider.execute(endpoint: endpoint)
            .map { $0 }
    }
    
    func deleteProduct(secret: String, productId: Int) -> Observable<Void> {
        let endpoint = APIEndpoints.productDelete(secret, productId).asEndpoint
        
        return networkProvider.execute(endpoint: endpoint)
            .map { _ in }
    }
}

extension DefaultProductRepository {
    private func generateFormData(by productRequest: ProductRequest) -> RequestDataInfo {
        let jsonData = try? JSONEncoder().encode(productRequest)
        let formData = RequestDataInfo(
            name: "params",
            fileName: nil,
            type: .json,
            data: jsonData
        )
        
        return formData
    }
    
    private func generateImageFormDatas(by images: [Data]) -> [RequestDataInfo] {
        let imageFormDatas = images.map {
            RequestDataInfo(
                name: "images",
                fileName: generateFileName(),
                type: .jpeg,
                data: $0
            )
        }
        
        return imageFormDatas
    }
    
    private func generateFileName() -> String {
      let date = Date()
      let dateFormatter = DateFormatter()
      dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
      let fileName = "\(dateFormatter.string(from: date)).jpeg"
        
      return fileName
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
