//
//  EndpointTests.swift
//  MMarketTests
//
//  Created by 조성훈 on 2022/11/24.
//

import XCTest

@testable import MMarket

class EndpointTests: XCTestCase {
    func test_get_productList_endpoint() {
        let endpoint = APIEndpoints
            .productList(1, 20, "test")
            .asEndpoint
        
        let request = try! endpoint.generateRequest()
        let url = request.url!
        
        XCTAssertTrue(url.absoluteString.hasPrefix("https://openmarket.yagom-academy.kr/api/products?"))
    }
    
    func test_get_productDetail_endpoint() {
        let endpoint = APIEndpoints
            .productDetail(1)
            .asEndpoint
        
        let request = try! endpoint.generateRequest()
        
        XCTAssertEqual(
            request.url,
            URL(string: "https://openmarket.yagom-academy.kr/api/products/1?")
        )
    }
    
    func test_post_productCreation_endpoint() {
        let entry = ProductRequest(
            name: "test",
            price: 1,
            discountedPrice: 1,
            stock: 1,
            currency: "test",
            description: "test",
            secret: "test"
        )
        let data = try! JSONEncoder().encode(entry)
        let endpoint = APIEndpoints
            .productCreation(data, "test_boundary")
            .asEndpoint
        
        let request = try! endpoint.generateRequest()
        
        let decodeData = try! JSONDecoder().decode(ProductRequest.self, from: request.httpBody!)
        XCTAssertEqual(request.url, URL(string: "https://openmarket.yagom-academy.kr/api/products?"))
        XCTAssertEqual(decodeData, entry)
    }
    
    func test_patch_productEdition_endpoint() {
        let entry = ProductRequest(
            name: "test",
            price: 1,
            discountedPrice: 1,
            stock: 1,
            currency: "test",
            description: "test",
            secret: "test"
        )
        let data = try! JSONEncoder().encode(entry)
        let endpoint = APIEndpoints
            .productEdition(data, 1)
            .asEndpoint
        
        let request = try! endpoint.generateRequest()
                
        let decodeData = try! JSONDecoder().decode(ProductRequest.self, from: request.httpBody!)
        XCTAssertEqual(request.url, URL(string: "https://openmarket.yagom-academy.kr/api/products/1?"))
        XCTAssertEqual(decodeData, entry)
    }
    
    func test_post_deleteURISearch_endpoint() {
        let password = "test111"
        let data = try! JSONEncoder().encode(password)
        
        let endpoint = APIEndpoints
            .deleteURISearch(data, 1)
            .asEndpoint
        
        let request = try! endpoint.generateRequest()
        
        let decodeData = try! JSONDecoder().decode(String.self, from: request.httpBody!)
        XCTAssertEqual(
            request.url,
            URL(string: "https://openmarket.yagom-academy.kr/api/products/1/archived?")
        )
        XCTAssertEqual(decodeData, password)
    }
    
    func test_delete_productDelete_endpoint() {
        let uri = "test"
        let endpoint = APIEndpoints
            .productDelete(uri)
            .asEndpoint
        
        let request = try! endpoint.generateRequest()
        
        XCTAssertEqual(
            request.url,
            URL(string: "https://openmarket.yagom-academy.krtest?")
        )
    }
}
