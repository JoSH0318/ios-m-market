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
    
    func start(with productID: Int) {
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
    
    func showEditView(with product: Product) {
        let editCoordinator = EditCoordinator(
            navigationController: self.navigationController,
            parentCoordinators: self,
            useCase: useCase
        )
        self.childCoordinators.append(editCoordinator)
        editCoordinator.start(with: product)
    }
    
    func popDetailView() {
        navigationController.popViewController(animated: true)
        parentCoordinators?.removeChildCoordinator(child: self)
    }
    
    func showErrorAlert() {
        let action = UIAlertAction(title: "확인", style: .cancel)
        let alert = AlertBuilder.shared
            .setType(.alert)
            .setTitle("오류")
            .setMessage("다시 한번 시도하세요.")
            .setActions([action])
            .apply()
        
        navigationController.present(alert, animated: true)
    }
    
    func showAlert() {
        let action = UIAlertAction(title: "확인", style: .cancel) { [weak self] _ in
            self?.popDetailView()
        }
        let alert = AlertBuilder.shared
            .setType(.alert)
            .setTitle("등록한 상품이 삭제됐습니다.")
            .setActions([action])
            .apply()
        
        navigationController.present(alert, animated: true)
    }
}
