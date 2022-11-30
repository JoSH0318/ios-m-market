//
//  ProductRepositoryTests.swift
//  MMarketTests
//
//  Created by 조성훈 on 2022/11/11.
//

import XCTest
import RxSwift

@testable import MMarket

final class ProductRepositoryTests: XCTestCase {
    private var dummyProductPages: ProductPagesDTO!
    private var networkProvider: NetworkProvider!
    private var sut: ProductRepository!
    private var disposeBag: DisposeBag!

    override func setUpWithError() throws {
        try super.setUpWithError()
        
        self.dummyProductPages = ProductPagesDTO(
            pageNumber: 1,
            itemsPerPage: 20,
            totalCount: 1,
            offset: 1,
            limit: 1,
            products: [
                ProductDTO(
                    id: 1,
                    venderId: 1,
                    name: "test",
                    description: "test",
                    thumbnail: "test",
                    currency: "test",
                    price: 1,
                    bargainPrice: 1,
                    discountedPrice: 1,
                    stock: 1,
                    images: nil,
                    vendor: nil,
                    createdAt: "2022/01/01",
                    issuedAt: "2022/01/01")
            ],
            lastPage: 10,
            hasNext: true,
            hasPrev: false
        )
        
        let dummyData = try! JSONEncoder().encode(self.dummyProductPages)
        self.networkProvider = StubNetworkProvider(data: dummyData, isSuccess: true)
        self.sut = DefaultProductRepository(networkProvider: networkProvider)
        self.disposeBag = DisposeBag()
    }

    override func tearDownWithError() throws {
        try super.tearDownWithError()
        self.dummyProductPages = nil
        self.networkProvider = nil
        self.sut = nil
        self.disposeBag = nil
    }
    
    func test_fetchProducts호출시_성공하면_ProductPage가_반환된다() throws {
        // given
        let expectation = XCTestExpectation()
        let dummyProductPages = dummyProductPages
        
        // when
        sut.fetchProducts(with: 1, 20, "test")
            .subscribe(onNext: { productPages in
                // then
                XCTAssertEqual(productPages, dummyProductPages)
                expectation.fulfill()
            }, onError: { _ in
                XCTFail()
            })
            .disposed(by: disposeBag)
        
        wait(for: [expectation], timeout: 5.0)
    }
    
    func test_fetchProduct호출시_성공하면_Product가_반환된다() throws {
        // given
        let expectation = XCTestExpectation()
        let dummyProduct =  ProductDTO(
            id: 1,
            venderId: 1,
            name: "test",
            description: "test",
            thumbnail: "test",
            currency: "test",
            price: 1,
            bargainPrice: 1,
            discountedPrice: 1,
            stock: 1,
            images: nil,
            vendor: nil,
            createdAt: "test",
            issuedAt: "test"
        )
        let dummyData = try! JSONEncoder().encode(dummyProduct)
        networkProvider = StubNetworkProvider(data: dummyData, isSuccess: true)
        sut = DefaultProductRepository(networkProvider: networkProvider)
        
        // when
        sut.fetchProduct(with: 1)
            .subscribe(onNext: { product in
                // then
                XCTAssertEqual(product, dummyProduct)
                expectation.fulfill()
            }, onError: { _ in
                XCTFail()
            })
            .disposed(by: disposeBag)
        
        wait(for: [expectation], timeout: 5.0)
    }
    
    func test_createProduct호출시_성공하면_response를_반환한다() throws {
        // given
        let expectation = XCTestExpectation()
        let productRequest = ProductRequest(
            name: "test",
            price: 1,
            discountedPrice: 1,
            stock: 1,
            currency: "test",
            description: "test",
            secret: "test"
        )
        let data = Data()
        
        // when
        sut.createProduct(with: productRequest, [data])
            .subscribe(onNext: { _ in
                // then
                expectation.fulfill()
            }, onError: { _ in
                XCTFail()
            })
            .disposed(by: disposeBag)
        
        wait(for: [expectation], timeout: 5.0)
    }
    
    func test_patchProduct호출시_성공하면_response를_반환한다() {
        // given
        let expectation = XCTestExpectation()
        let productRequest = ProductRequest(
            name: "test",
            price: 1,
            discountedPrice: 1,
            stock: 1,
            currency: "test",
            description: "test",
            secret: "test"
        )
        
        // when
        sut.patchProduct(with: productRequest, 1)
            .subscribe(onNext: {
                // then
                expectation.fulfill()
            }, onError: { _ in
                XCTFail()
            })
            .disposed(by: disposeBag)
        
        wait(for: [expectation], timeout: 5.0)
    }
    
    func test_searchDeleteURI호출시_성공하면_data를_반환한다() {
        // given
        let expectation = XCTestExpectation()
        let dummyUri = "test"
        let dummyData = try! JSONEncoder().encode(dummyUri)
        networkProvider = StubNetworkProvider(data: dummyData, isSuccess: true)
        sut = DefaultProductRepository(networkProvider: networkProvider)
        
        // when
        sut.searchDeleteURI(with: "test", 1)
            .map { try! JSONDecoder().decode(String.self, from: $0) }
            .subscribe(onNext: { deleteUri in
                // then
                XCTAssertEqual(deleteUri, dummyUri)
                expectation.fulfill()
            }, onError: { _ in
                XCTFail()
            })
            .disposed(by: disposeBag)
        
        wait(for: [expectation], timeout: 5.0)
    }
    
    func test_deleteProduct호출시_성공하면_response를_반환한다() {
        // given
        let expectation = XCTestExpectation()
        
        // when
        sut.deleteProduct(with: "test")
            .subscribe(onNext: {
                // then
                expectation.fulfill()
            }, onError: { _ in
                XCTFail()
            })
            .disposed(by: disposeBag)
        
        wait(for: [expectation], timeout: 5.0)
    }
}
