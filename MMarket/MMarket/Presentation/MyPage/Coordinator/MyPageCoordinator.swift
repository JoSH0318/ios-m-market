//
//  MyPageCoordinator.swift
//  MMarket
//
//  Created by 조성훈 on 2022/11/21.
//

import UIKit

final class MyPageCoordinator: Coordinator {
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
        let myPageViewModel = MyPageViewModel(productUseCase: useCase, coordinator: self)
        let myPageViewController = MyPageViewController(viewModel: myPageViewModel)
        self.navigationController.pushViewController(myPageViewController, animated: true)
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
}

