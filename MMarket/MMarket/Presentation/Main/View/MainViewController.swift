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
    private let disposeBag = DisposeBag()
    
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
        view = MainView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bind()
    }
    
    private func bind() {
        viewModel.products
            .bind(to: mainView.productListCollectionView.rx.items(
                cellIdentifier: ProductListCell.idenfier,
                cellType: ProductListCell.self
            )) { _, item, cell in
                cell.bind(product: item)
            }
            .disposed(by: disposeBag)
    }
}

// MARK: - Layout

extension MainViewController {
    private func configureLayout() {}
}

// MARK: - DataSource

extension MainViewController {}
