//
//  MainView.swift
//  MMarket
//
//  Created by 조성훈 on 2022/08/18.
//

import SnapKit

final class MainView: UIView {
    private(set) lazy var productListCollectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: configureProductListLayout()
    )
    
    private(set) var registerButton: UIButton = {
        let button = UIButton()
        button.setBackgroundImage(UIImage(systemName: "plus.circle.fill"), for: .normal)
        button.tintColor = UIColor.navyColor
        button.backgroundColor = .systemBackground
        button.clipsToBounds = true
        return button
    }()
    
    private(set) var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.placeholder = "상품을 검색해주세요."
        searchBar.searchTextField.font = .systemFont(ofSize: 16)
        searchBar.searchBarStyle = .minimal
        return searchBar
    }()
    
    init() {
        super.init(frame: .zero)
        
        configureView()
        configureConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        registerButton.layer.cornerRadius = registerButton.frame.width * 0.5
    }
    
    private func configureProductListLayout() -> UICollectionViewCompositionalLayout {
        return UICollectionViewCompositionalLayout { _, env in
            let width = (env.container.effectiveContentSize.width) * 0.5
            let height = width * 1.4
            
            let itemSize = NSCollectionLayoutSize(
                widthDimension: .absolute(width),
                heightDimension: .absolute(height)
            )
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            
            let groupSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .absolute(height)
            )
            let group = NSCollectionLayoutGroup.horizontal(
                layoutSize: groupSize,
                subitems: [item]
            )
            let section = NSCollectionLayoutSection(group: group)
            
            return section
        }
    }
    
    private func configureView() {
        backgroundColor = .systemBackground
        
        addSubview(searchBar)
        addSubview(productListCollectionView)
        addSubview(registerButton)
        
        productListCollectionView.register(
            ProductListCell.self,
            forCellWithReuseIdentifier: ProductListCell.identifier
        )
    }
    
    private func configureConstraints() {
        searchBar.snp.makeConstraints {
            $0.leading.top.equalTo(safeAreaLayoutGuide).offset(8)
            $0.trailing.equalTo(safeAreaLayoutGuide).offset(-8)
            $0.height.equalTo(35)
        }
        
        productListCollectionView.snp.makeConstraints {
            $0.top.equalTo(searchBar.snp.bottom).offset(4)
            $0.leading.equalToSuperview().offset(8)
            $0.trailing.equalToSuperview().offset(-8)
            $0.bottom.equalToSuperview()
        }
        
        registerButton.snp.makeConstraints {
            $0.width.height.equalTo(50)
            $0.trailing.bottom.equalTo(safeAreaLayoutGuide).offset(-20)
        }
    }
}
