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
    private let mainView = MainView()
    private var viewModel: MainViewModel
    private var coordinator: MainCoordinator
    private let disposeBag = DisposeBag()
    
    private let refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.tintColor = .darkGray
        return refreshControl
    }()
    
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
        
        viewModel.didLaunchView()
    }
    
    private func bind() {
        viewModel.products
            .bind(to: mainView.productListCollectionView.rx.items(
                cellIdentifier: ProductListCell.identifier,
                cellType: ProductListCell.self
            )) { _, item, cell in
                cell.bind(with: item)
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
            .subscribe(onNext: { [weak self] text in
                self?.viewModel.didBeginEditingSearchBar(text)
            })
            .disposed(by: disposeBag)
        
        mainView.productListCollectionView.rx.prefetchItems
            .compactMap { $0.last?.row }
            .withUnretained(self)
            .bind { vc, row in
                vc.viewModel.didScrollToNextPage(row)
            }
            .disposed(by: disposeBag)
    }
    
    private func refreshMainView() {
        viewModel.didLaunchView()
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
        navigationItem.titleView = generateNavigationTitleView()
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont(
            name: "BM HANNA Pro",
            size: 20
        ) as Any]
        navigationController?.navigationBar.backgroundColor = .systemGray5
    }
    
    private func generateNavigationTitleView() -> UIStackView {
        let stackView = UIStackView()
        let label = UILabel()
        label.text = " M-MARKET"
        label.font = UIFont(name: "BM HANNA Pro", size: 25)
        let imageView = UIImageView()
        imageView.image = UIImage(named: "AppIcon")
        stackView.addArrangedSubview(imageView)
        stackView.addArrangedSubview(label)
        
        return stackView
    }
}
