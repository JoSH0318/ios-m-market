//
//  ProductRepositoryTests.swift
//  MMarketTests
//
//  Created by 조성훈 on 2022/11/11.
//

import XCTest
import RxSwift

@testable import MMarket

class ProductRepositoryTests: XCTestCase {
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

    func test_d() throws {
        
        
    }

}
