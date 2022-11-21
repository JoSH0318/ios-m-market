//
//  MyPageViewController.swift
//  MMarket
//
//  Created by 조성훈 on 2022/11/21.
//

import SnapKit
import RxSwift
import RxCocoa

final class MyPageViewController: UIViewController {
    private let myPageView = MyPageView()
    private var viewModel: MyPageViewModel
    private let disposeBag = DisposeBag()
    
    init(viewModel: MyPageViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        
        configureNavigationBar()
        bind()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = myPageView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    private func bind() {
        viewModel.products
            .bind(to: myPageView.productListCollectionView.rx.items(
                cellIdentifier: ProductListCell.identifier,
                cellType: ProductListCell.self
            )) { _, item, cell in
                cell.bind(with: item)
            }
            .disposed(by: disposeBag)
        
        myPageView.productListCollectionView.rx.modelSelected(Product.self)
            .withUnretained(self)
            .bind { vc, item in
                vc.viewModel.didTapCell(item)
            }
            .disposed(by: disposeBag)
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
        label.text = " 마이페이지"
        label.font = UIFont(name: "BM HANNA Pro", size: 25)
        let imageView = UIImageView()
        imageView.image = UIImage(named: "AppIcon")
        imageView.contentMode = .scaleAspectFit
        stackView.addArrangedSubview(imageView)
        stackView.addArrangedSubview(label)
        
        return stackView
    }
}
