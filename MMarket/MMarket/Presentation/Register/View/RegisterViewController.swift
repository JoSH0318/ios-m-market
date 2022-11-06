//
//  RegisterViewController.swift
//  MMarket
//
//  Created by 조성훈 on 2022/11/05.
//

import UIKit
import RxSwift
import RxRelay
import RxCocoa

final class RegisterViewController: UIViewController {
    
    private let backBarButton: UIBarButtonItem = {
        let backImage = UIImage(systemName: "chevron.backward")
        let barButtonItem = UIBarButtonItem(
            image: backImage,
            style: .plain,
            target: nil,
            action: nil
        )
        barButtonItem.tintColor = .darkGray
        return barButtonItem
    }()

    private let completionBarButton: UIBarButtonItem = {
        let barButtonItem = UIBarButtonItem(
            image: nil,
            style: .plain,
            target: nil,
            action: nil
        )
        barButtonItem.title = "완료"
        barButtonItem.tintColor = .darkGray
        return barButtonItem
    }()
    
    private let registerView = RegisterView()
    private var viewModel: RegisterViewModel
    private var coordinator: RegisterCoordinator
    private let disposeBag = DisposeBag()
    
    init(
        viewModel: RegisterViewModel,
        coordinator: RegisterCoordinator
    ) {
        self.viewModel = viewModel
        self.coordinator = coordinator
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        
        view = registerView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureNavigationBar()
        bind()
    }
    
    private func bind() {
        backBarButton.rx.tap
            .withUnretained(self)
            .subscribe(onNext: { vc, _ in
                vc.coordinator.popRegisterView()
            })
            .disposed(by: disposeBag)
        
        completionBarButton.rx.tap
            .withUnretained(self)
            .subscribe(onNext: { vc, _ in
                let productRequest = vc.registerView.setProductRequest()
//                vc.viewModel.didTapPostButton(productRequest, images: <#T##[Data]#>)
            })
            .disposed(by: disposeBag)
        
        viewModel.postProdct
            .withUnretained(self)
            .subscribe(onNext: { vc, _ in
                vc.coordinator.popRegisterView()
            })
            .disposed(by: disposeBag)
    }
}

// MARK: - NavigationBar Layout

extension RegisterViewController {
    private func configureLayout() {}
    private func configureNavigationBar() {
        navigationItem.leftBarButtonItem = backBarButton
        navigationItem.rightBarButtonItem = completionBarButton
        navigationItem.title = "M-Market"
        navigationController?.navigationBar.backgroundColor = .systemGray5
    }
}
