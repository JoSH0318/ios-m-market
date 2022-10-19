//
//  MainViewController.swift
//  MMarket
//
//  Created by 조성훈 on 2022/08/16.
//

import UIKit
import RxSwift
import RxRelay
import RxCocoa

class MainViewController: UIViewController {
    private let mainView = MainView()
    private var viewModel: MainViewModel
    private var coordinator: Coordinator
    
    init(
        viewModel: MainViewModel,
        coordinator: MainCoordinator
    ) {
        self.viewModel = viewModel
        self.coordinator = coordinator
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

// MARK: - Layout

extension MainViewController {
    private func configureLayout() {}
}

// MARK: - DataSource

extension MainViewController {}
