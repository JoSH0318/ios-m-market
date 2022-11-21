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
            productUseCase: useCase,
            coordinator: self
        )
        let registerViewController = RegisterViewController(
            viewModel: registerViewModel
        )
        self.navigationController.pushViewController(registerViewController, animated: true)
    }
    
    func popRegisterView() {
        navigationController.popViewController(animated: true)
        parentCoordinators?.removeChildCoordinator(child: self)
    }
    
    func showAlert(with title: String) {
        let confirmAction = UIAlertAction(title: "확인", style: .default)  { [weak self] _ in
            self?.popRegisterView()
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
    
    func showPhotoLibrary(to imagePicker: UIImagePickerController) {
        navigationController.present(imagePicker, animated: true)
    }
    
    func removePhotoLibrary(to imagePicker: UIImagePickerController) {
        imagePicker.dismiss(animated: true)
    }
}
