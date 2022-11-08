//
//  EditViewController.swift
//  MMarket
//
//  Created by 조성훈 on 2022/11/08.
//

import UIKit
import RxSwift
import RxCocoa

class EditViewController: UIViewController {
    
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
        barButtonItem.setTitleTextAttributes(
            [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16, weight: .bold)],
            for: .normal
        )
        barButtonItem.tintColor = UIColor(named: "MainBeigeColor")
        return barButtonItem
    }()
    
    private let editView = RegisterView()
    private var viewModel: EditViewModel
    private var coordinator: EditCoordinator
    private let disposeBag = DisposeBag()
    
    init(
        viewModel: EditViewModel,
        coordinator: EditCoordinator
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
        
        view = editView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureNavigationBar()
        bind()
    }
    
    private func bind() {
        
    }
}

extension EditViewController {
    private func configureNavigationBar() {
        navigationItem.leftBarButtonItem = backBarButton
        navigationItem.rightBarButtonItem = completionBarButton
        navigationItem.title = "상품 수정하기"
        navigationController?.navigationBar.backgroundColor = .systemGray5
    }
}
