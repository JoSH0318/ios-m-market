//
//  MainViewController.swift
//  MMarket
//
//  Created by 조성훈 on 2022/08/16.
//

import SnapKit
import RxSwift
import RxCocoa

final class MainViewController: UIViewController {
    
    private let refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.tintColor = .darkGray
        return refreshControl
    }()
    
    private let mainView = MainView()
    private var viewModel: MainViewModel
    private var coordinator: MainCoordinator
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
        
        configureView()
        bind()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        viewModel.fetchProducts(with: 1)
    }
    
    private func bind() {
        viewModel.products
            .observe(on: MainScheduler.instance)
            .bind(to: mainView.productListCollectionView.rx.items(
                cellIdentifier: ProductListCell.idenfier,
                cellType: ProductListCell.self
            )) { _, item, cell in
                cell.bind(with: ProductListCellViewModel(product: item))
            }
            .disposed(by: disposeBag)
        
        mainView.productListCollectionView.rx.modelSelected(Product.self)
            .withUnretained(self)
            .bind { vc, item in
                vc.viewModel.didTapCell(item)
            }
            .disposed(by: disposeBag)
        
        viewModel.showDetailView
            .withUnretained(self)
            .bind { vc, product in
                vc.coordinator.showDetailView(productID: product.id)
            }
            .disposed(by: disposeBag)
        
        mainView.registerButton.rx.tap
            .withUnretained(self)
            .subscribe(onNext: { vc, _ in
                vc.coordinator.showRegisterView()
            })
            .disposed(by: disposeBag)
        
        refreshControl.rx.controlEvent(.valueChanged)
            .withUnretained(self)
            .subscribe(onNext: { vc, _ in
                vc.refreshMainView()
            })
            .disposed(by: disposeBag)
        
        mainView.searchBar.rx.text.orEmpty
            .debounce(RxTimeInterval.milliseconds(500), scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .filter{ !$0.isEmpty }
            .subscribe(onNext: { [weak self] text in
                self?.viewModel.didBeginEditingSerachBar(text)
            })
            .disposed(by: disposeBag)
    }
    
    private func refreshMainView() {
        viewModel.fetchProducts(with: 1)
        mainView.productListCollectionView.refreshControl?.endRefreshing()
    }
}

// MARK: - Layout

extension MainViewController {
    private func configureView() {
        mainView.productListCollectionView.refreshControl = refreshControl
        configureNavigationBar()
    }
    
    private func configureNavigationBar() {
        navigationItem.title = "M-MARKET"
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont(
            name: "BM DoHyeon OTF",
            size: 20
        ) as Any]
        navigationController?.navigationBar.backgroundColor = .systemGray5
    }
}
