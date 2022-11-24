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
    private let mockDataManager = MockDataManager()
    private var sut: NetworkProvider!
    private var disposeBag: DisposeBag!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        
        let urlSession = self.mockDataManager.makeMockUrlSession()
        self.sut = DefaultNetworkProvider(urlSession: urlSession)
        self.disposeBag = DisposeBag()
    }

    override func tearDownWithError() throws {
        try super.tearDownWithError()
        
        self.sut = nil
        self.disposeBag = nil
    }

    func test_올바른_request로_execute요청시_HTTPResponse_StatuseCode가_200이고_데이터가_방출되는가() throws {
        // given
        let promise = expectation(description: "status Code 200")
        mockDataManager.makeRequestSuccessResult()
        let endpoint = Endpoint(
            baseURL: "https://MMarketTest.kr",
            path: "/api/test",
            method: .get
        )
        
        // when
        sut.execute(endpoint: endpoint)
            .subscribe(onNext: { data in
                
                // then
                XCTAssertTrue(true)
                promise.fulfill()
            }, onError: { _ in
                XCTFail()
            })
            .disposed(by: disposeBag)
        wait(for: [promise], timeout: 5)
    }
    
    func test_잘못된_request로_execute요청시_HTTPResponse_StatuseCode가_400인가() throws {
        // given
        let promise = expectation(description: "status Code 400")
        mockDataManager.makeRequestFailureResult()
        let endpoint = Endpoint(
            baseURL: "https://MMarketTest.kr",
            path: "/api/test",
            method: .get
        )
        
        // when
        sut.execute(endpoint: endpoint)
            .subscribe(onNext: { _ in
                XCTFail()
            }, onError: { _ in
                
                // then
                XCTAssertTrue(true)
                promise.fulfill()
            })
            .disposed(by: disposeBag)
        wait(for: [promise], timeout: 5)
    }
}
