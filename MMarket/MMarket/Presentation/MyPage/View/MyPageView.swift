//
//  MyPageView.swift
//  MMarket
//
//  Created by 조성훈 on 2022/11/22.
//

import SnapKit

final class MyPageView: UIView {
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
            let height = width * 1.3
            
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
        
        addSubview(productListCollectionView)
        addSubview(registerButton)
        
        productListCollectionView.register(
            ProductListCell.self,
            forCellWithReuseIdentifier: ProductListCell.identifier
        )
    }
    
    private func configureConstraints() {
        productListCollectionView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.trailing.bottom.equalToSuperview()
        }
        
        registerButton.snp.makeConstraints {
            $0.width.height.equalTo(50)
            $0.trailing.bottom.equalTo(safeAreaLayoutGuide).offset(-20)
        }
    }
}

