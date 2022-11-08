//
//  MainCoordinator.swift
//  MMarket
//
//  Created by 조성훈 on 2022/10/20.
//

import UIKit

final class MainCoordinator: Coordinator {
    var navigationController: UINavigationController
    var parentCoordinators: Coordinator?
    var childCoordinators: [Coordinator] = []
    private let useCase: ProductUseCase
    
    init(
        navigationController: UINavigationController,
        parentCoordinators: Coordinator,
        useCase: ProductUseCase
    ) {
        self.navigationController = navigationController
        self.parentCoordinators = parentCoordinators
        self.useCase = useCase
    }
    
    func start() {
        let mainViewModel = MainViewModel(productUseCase: useCase)
        let mainViewController = MainViewController(viewModel: mainViewModel, coordinator: self)
        self.navigationController.pushViewController(mainViewController, animated: true)
    }
    
    func showDetailView(productID: Int) {
        let detailCoordinator = DetailCoordinator(
            navigationController: self.navigationController,
            parentCoordinators: self,
            useCase: useCase
        )
        self.childCoordinators.append(detailCoordinator)
        detailCoordinator.start(with: productID)
    }
    
    func showRegisterView() {
        let registerCoordinator = RegisterCoordinator(
            navigationController: self.navigationController,
            parentCoordinators: self,
            useCase: useCase
        )
        self.childCoordinators.append(registerCoordinator)
        registerCoordinator.start()
    }
}
