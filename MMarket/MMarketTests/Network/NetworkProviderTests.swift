//
//  NetworkProviderTests.swift
//  MMarketTests
//
//  Created by 조성훈 on 2022/11/11.
//

import XCTest
import RxSwift

@testable import MMarket

final class NetworkProviderTests: XCTestCase {
    private let stubURLProtocolManager = StubURLProtocolManager()
    private var sut: NetworkProvider!
    private var disposeBag: DisposeBag!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        
        let urlSession = self.stubURLProtocolManager.makeSubUrlSession()
        self.sut = DefaultNetworkProvider(urlSession: urlSession)
        self.disposeBag = DisposeBag()
    }

    override func tearDownWithError() throws {
        try super.tearDownWithError()
        
        self.sut = nil
        self.disposeBag = nil
    }

    func test_execute호출시_statusCode_200이면_success() throws {
        // given
        let expectation = XCTestExpectation(description: "Success")
        
        stubURLProtocolManager.makeSuccessRequest()
        
        let endpoint = APIEndpoints
            .productList(1, 20, "")
            .asEndpoint
        
        // when
        sut.execute(endpoint: endpoint)
            .decode(type: ProductPagesDTO.self, decoder: JSONDecoder())
            .subscribe(onNext: { _ in
                // then
                XCTAssertTrue(true)
                expectation.fulfill()
            }, onError: { _ in
                XCTFail()
            })
            .disposed(by: disposeBag)
        wait(for: [expectation], timeout: 5.0)
    }
    
    func test_execute호출시_statusCode_400이면_failure() throws {
        // given
        let expectation = expectation(description: "Failure")
        
        stubURLProtocolManager.makeFailureRequest()
        
        let endpoint = Endpoint(
            baseURL: "https://MMarketTest.kr",
            path: "/api/test",
            method: .get
        )
        
        // when
        sut.execute(endpoint: endpoint)
            .subscribe(onNext: { _ in
                // then
                XCTFail()
            }, onError: { _ in
                XCTAssertTrue(true)
                expectation.fulfill()
            })
            .disposed(by: disposeBag)
        wait(for: [expectation], timeout: 5)
    }
}
