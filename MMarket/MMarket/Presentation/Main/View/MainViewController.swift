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
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureNavigationBar()
        bind()
    }
    
    private func bind() {
        viewModel.products
            .bind(to: mainView.productListCollectionView.rx.items(
                cellIdentifier: ProductListCell.idenfier,
                cellType: ProductListCell.self
            )) { _, item, cell in
                cell.bind(with: ProductListCellViewModel(product: item))
            }
            .disposed(by: disposeBag)
        
        mainView.productListCollectionView.rx.modelSelected(Product.self)
            .bind { [weak self] item in
                self?.viewModel.didTapCell(item)
            }
            .disposed(by: disposeBag)
        
//        viewModel.showDetailView
//            .bind { [weak self] product in
//                <#code#>
//            }
    }
}

// MARK: - Layout

extension MainViewController {
    private func configureLayout() {}
    private func configureNavigationBar() {
        navigationItem.title = "M-Market"
        navigationController?.navigationBar.backgroundColor = .systemGray5
    }
}

// MARK: - DataSource

extension MainViewController {}
