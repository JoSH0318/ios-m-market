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
    
    func test_fetchProducts호출시_통신에_성공하면_올바른_ProductPage가_반환된다() throws {
        // given
        let dummyProductPages = dummyProductPages
        
        // when
        sut.fetchProducts(with: 1, 20, "test")
            .subscribe(onNext: { productpages in
                // then
                XCTAssertEqual(dummyProductPages, productpages)
                XCTAssertEqual(productpages.products.count, 1)
            }, onError: { _ in
                XCTFail()
            })
            .disposed(by: disposeBag)
    }
    
    func test_fetchProduct호출시_통신에_성공하면_올바른_Product가_반환된다() throws {
        // given
        let dummyProduct = dummyProductPages.map { $0.products }!.first
        
        // when
        sut.fetchProduct(with: 1)
            .subscribe(onNext: { product in
                // then
                XCTAssertEqual(dummyProduct, product)
            }, onError: { _ in
                XCTFail()
            })
            .disposed(by: disposeBag)
    }
}


