//
//  DetailView.swift
//  MMarket
//
//  Created by 조성훈 on 2022/11/02.
//

import SnapKit

final class DetailView: UIView {
    
    private enum FontSize {
        static let title = 20.0
        static let body = 16.0
    }
    
    private var viewModel: ProductListCellViewModel?
    private let scrollView = UIScrollView()
    private(set) lazy var imagesCollectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: configureCollectionFlowLayout()
    )
    
    static var idenfier: String {
        return String(describing: self)
    }
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.font = .systemFont(ofSize: FontSize.title, weight: .bold)
        return label
    }()
    
    private let stockLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.font = .systemFont(ofSize: FontSize.body)
        label.textColor = .systemGray3
        return label
    }()
    
    private let bargainPriceLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.font = .systemFont(ofSize: FontSize.title, weight: .bold)
        label.setContentHuggingPriority(.init(rawValue: 1), for: .horizontal)
        return label
    }()
    
    private let priceLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.font = .systemFont(ofSize: FontSize.body)
        label.textColor = .systemGray3
        return label
    }()
    
    private let discountRateLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .right
        label.font = .systemFont(ofSize: FontSize.title)
        label.textColor = .systemRed
        label.setContentCompressionResistancePriority(.required, for: .horizontal)
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.font = .systemFont(ofSize: FontSize.title)
        label.numberOfLines = 0
        return label
    }()
    
    private let totalPriceStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 4
        return stackView
    }()
    
    private let bargainPriceStackView: UIStackView = {
        let stackView = UIStackView()
        return stackView
    }()
    
    private let totalStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .equalCentering
        stackView.spacing = 8
        return stackView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .systemBackground
        configureLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureCollectionFlowLayout() -> UICollectionViewFlowLayout {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        flowLayout.itemSize = CGSize(
            width: UIScreen.main.bounds.width,
            height: UIScreen.main.bounds.height
        )
        flowLayout.scrollDirection = .horizontal
        
        return flowLayout
    }
    
    func setContents(with detailProduct: DetailViewModelItem) {
        nameLabel.text = detailProduct.name
        stockLabel.text = detailProduct.stock
        bargainPriceLabel.text = detailProduct.bargainPrice
        priceLabel.text = detailProduct.price
        discountRateLabel.text = detailProduct.discountRate
        descriptionLabel.text = detailProduct.description
    }
    
    private func configureLayout() {
        addSubview(scrollView)
        scrollView.addSubview(imagesCollectionView)
        scrollView.addSubview(totalStackView)
        
        bargainPriceStackView.addArrangedSubview(bargainPriceLabel)
        bargainPriceStackView.addArrangedSubview(discountRateLabel)
        
        totalPriceStackView.addArrangedSubview(bargainPriceStackView)
        totalPriceStackView.addArrangedSubview(priceLabel)
        
        totalStackView.addArrangedSubview(nameLabel)
        totalStackView.addArrangedSubview(stockLabel)
        totalStackView.addArrangedSubview(totalPriceStackView)
        totalStackView.addArrangedSubview(descriptionLabel)
        
        imagesCollectionView.snp.makeConstraints {
            $0.leading.top.trailing.equalToSuperview()
            $0.width.equalToSuperview()
            $0.height.equalTo(imagesCollectionView.snp.width)
            $0.bottom.equalTo(totalStackView.snp.top).offset(-16)
        }
        
        totalStackView.snp.makeConstraints {
            $0.leading.bottom.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview().offset(-20)
        }
        
        scrollView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        imagesCollectionView.register(
            DetailViewImagesCell.self,
            forCellWithReuseIdentifier: DetailViewImagesCell.idenfier
        )
    }
}
