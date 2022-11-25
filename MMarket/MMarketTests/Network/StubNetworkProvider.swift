//
//  StubNetworkProvider.swift
//  MMarketTests
//
//  Created by 조성훈 on 2022/11/25.
//

import Foundation
import RxSwift

@testable import MMarket

final class StubNetworkProvider: NetworkProvider {
    let data: Data
    let isSuccess: Bool
    
    init(data: Data, isSuccess: Bool) {
        self.data = data
        self.isSuccess = isSuccess
    }
    
    func execute(endpoint: Endpoint) -> Observable<Data> {
        switch isSuccess {
        case true:
            return .just(data)
        case false:
            return .error(NetworkError.invalidResponse)
        }
    }
}
