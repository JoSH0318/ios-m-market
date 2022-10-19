//
//  AppCoordinator.swift
//  MMarket
//
//  Created by 조성훈 on 2022/10/19.
//

import UIKit

final class AppCoordinator: Coordinator {
    var navigationController: UINavigationController
    var parentCoordinators: Coordinator?
    var childCoordinators: [Coordinator] = []
    private let useCase: ProductUseCase = DefaultProductUseCase(
        repository: DefaultProductRepository(
            networkProvider: DefaultNetworkProvider()
        )
    )
    
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let mainCoordinator = MainCoordinator(
            navigationController: self.navigationController,
            parentCoordinators: self,
            useCase: self.useCase
        )
        self.childCoordinators.append(mainCoordinator)
        mainCoordinator.start()
    }
}
