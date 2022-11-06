//
//  DetailCoordinator.swift
//  MMarket
//
//  Created by 조성훈 on 2022/11/02.
//

import UIKit

final class DetailCoordinator: Coordinator {
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
    
    func start(productID: Int) {
        let detailViewModel = DetailViewModel(
            productUseCase: useCase,
            productID: productID
        )
        let detailViewController = DetailViewController(
            viewModel: detailViewModel,
            coordinator: self
        )
        self.navigationController.pushViewController(detailViewController, animated: true)
    }
    
    func popDetailView() {
        navigationController.popViewController(animated: true)
        parentCoordinators?.removeChildCoordinator(child: self)
    }
}
