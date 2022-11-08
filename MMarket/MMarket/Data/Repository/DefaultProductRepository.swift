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
    
    func fetchAll(with pageNumber: Int, _ itemsPerPage: Int) -> Observable<ProductPagesDTO> {
        let endpoint = APIEndpoints
            .productList(pageNumber, itemsPerPage)
            .asEndpoint
        
        return networkProvider
            .execute(endpoint: endpoint)
            .decode(type: ProductPagesDTO.self, decoder: JSONDecoder())
    }
    
    func searchProducts(with searchValue: String) -> Observable<ProductPagesDTO> {
        let endpoint = APIEndpoints
            .searchedProducts(searchValue)
            .asEndpoint
        
        return networkProvider
            .execute(endpoint: endpoint)
            .decode(type: ProductPagesDTO.self, decoder: JSONDecoder())
    }
    
    func fetchProduct(with productID: Int) -> Observable<ProductDTO> {
        let endpoint = APIEndpoints
            .productDetail(productID)
            .asEndpoint
        
        return networkProvider
            .execute(endpoint: endpoint)
            .decode(type: ProductDTO.self, decoder: JSONDecoder())
    }
    
    func createProduct(with productRequest: ProductRequest, _ images: [Data]) -> Observable<Void> {
        let boundary = UUID().uuidString
        let formData = generateFormData(from: productRequest)
        let imageFormDatas = generateImageFormDatas(from: images)
        let body = HTTPBodyBuilder
            .create(uuid: boundary)
            .append(formData)
            .append(imageFormDatas)
            .apply()
        let endpoint = APIEndpoints
            .productCreation(body, boundary)
            .asEndpoint
        
        return networkProvider.execute(endpoint: endpoint)
            .map { _ in }
    }
    
    func patchProduct(with productRequest: ProductRequest, _ productID: Int) -> Observable<Void> {
        let formData = generateFormData(from: productRequest)
        let body = HTTPBodyBuilder
            .create()
            .append(formData)
            .apply()
        let endpoint = APIEndpoints
            .productEdition(body, productID)
            .asEndpoint
        
        return networkProvider
            .execute(endpoint: endpoint)
            .map { _ in }
    }
    
    func searchDeleteURI(with password: String, _ productID: Int) -> Observable<Data> {
        let body = HTTPBodyBuilder
            .create()
            .append(password)
            .apply()
        let endpoint = APIEndpoints
            .deleteURISearch(body, productID)
            .asEndpoint
        
        return networkProvider
            .execute(endpoint: endpoint)
            .map { $0 }
    }
    
    func deleteProduct(with deleteURI: String) -> Observable<Void> {
        let endpoint = APIEndpoints
            .productDelete(deleteURI)
            .asEndpoint
        
        return networkProvider
            .execute(endpoint: endpoint)
            .map { _ in }
    }
}

extension DefaultProductRepository {
    private func generateFormData(from productRequest: ProductRequest) -> RequestDataInfo {
        let jsonData = try? JSONEncoder().encode(productRequest)
        let formData = RequestDataInfo(
            name: "params",
            fileName: nil,
            type: .json,
            data: jsonData
        )
        
        return formData
    }
    
    private func generateImageFormDatas(from images: [Data]) -> [RequestDataInfo] {
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
