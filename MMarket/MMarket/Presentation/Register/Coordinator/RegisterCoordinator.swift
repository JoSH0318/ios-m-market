//
//  RegisterCoordinator.swift
//  MMarket
//
//  Created by 조성훈 on 2022/11/04.
//

import UIKit

final class RegisterCoordinator: Coordinator {
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
        let registerViewModel = RegisterViewModel(
            productUseCase: useCase
        )
        let registerViewController = RegisterViewController(
            viewModel: registerViewModel,
            coordinator: self
        )
        self.navigationController.pushViewController(registerViewController, animated: true)
    }
    
    func popRegisterView() {
        navigationController.popViewController(animated: true)
        parentCoordinators?.removeChildCoordinator(child: self)
    }
}
