//
//  EditCoordinator.swift
//  MMarket
//
//  Created by 조성훈 on 2022/11/08.
//

import UIKit

final class EditCoordinator: Coordinator {
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
    
    func start(with product: Product) {
        let editViewModel = EditViewModel(
            productUseCase: useCase,
            product: product
        )
        let editViewController = EditViewController(
            viewModel: editViewModel,
            coordinator: self
        )
        self.navigationController.pushViewController(editViewController, animated: true)
    }
    
    func popEditView() {
        navigationController.popViewController(animated: true)
        parentCoordinators?.removeChildCoordinator(child: self)
    }
    
    func showAlert(with title: String) {
        let confirmAction = UIAlertAction(title: "확인", style: .default)  { [weak self] _ in
            self?.popEditView()
        }
        let alert = AlertBuilder.shared
            .setType(.alert)
            .setTitle(title)
            .setActions([confirmAction])
            .apply()
        
        navigationController.present(alert, animated: true)
    }
    
    func showErrorAlert() {
        let action = UIAlertAction(title: "확인", style: .cancel)
        let alert = AlertBuilder.shared
            .setType(.alert)
            .setTitle("입력하지 않은 정보가 있습니다.")
            .setMessage("다시 한번 확인하세요.")
            .setActions([action])
            .apply()
        
        navigationController.present(alert, animated: true)
    }
}

