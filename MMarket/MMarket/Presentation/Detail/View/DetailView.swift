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
        static let subtitle = 18.0
        static let body = 16.0
    }
    
    private var viewModel: ProductListCellViewModel?
    private let scrollView = UIScrollView()
    private(set) lazy var imagesCollectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: configureCollectionFlowLayout()
    )
    
    static var identifier: String {
        return String(describing: self)
    }
    
    private let userInformationStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.alignment = .center
        stackView.spacing = 8
        return stackView
    }()
    
    private let userImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "person.circle.fill")
        imageView.tintColor = .darkGray
        return imageView
    }()
    
    private let userNameLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.font = .systemFont(ofSize: FontSize.body, weight: .bold)
        label.setContentHuggingPriority(.init(rawValue: 1), for: .horizontal)
        return label
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.font = .systemFont(ofSize: FontSize.title, weight: .bold)
        return label
    }()
    
    private let bargainStackView = UIStackView()
    
    private let bargainPriceLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.font = .systemFont(ofSize: FontSize.subtitle, weight: .bold)
        label.setContentHuggingPriority(.init(rawValue: 1), for: .horizontal)
        return label
    }()
    
    private let discountRateLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .right
        label.font = .systemFont(ofSize: FontSize.subtitle)
        label.textColor = .systemRed
        label.setContentCompressionResistancePriority(.required, for: .horizontal)
        return label
    }()
    
    private let additionalStackView = UIStackView()
    
    private let priceLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.font = .systemFont(ofSize: FontSize.body)
        label.textColor = .systemGray3
        label.setContentHuggingPriority(.init(rawValue: 1), for: .horizontal)
        return label
    }()
    
    private let stockLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.font = .systemFont(ofSize: FontSize.body)
        label.textColor = .systemGray3
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.font = .systemFont(ofSize: FontSize.subtitle)
        label.numberOfLines = 0
        return label
    }()

    private let informationStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 4
        return stackView
    }()
    
    private let mainStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .equalSpacing
        stackView.spacing = 16
        return stackView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .systemBackground
        configureView()
        configureConstraints()
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
        flowLayout.minimumLineSpacing = 0
        flowLayout.scrollDirection = .horizontal
        
        return flowLayout
    }
    
    func setContents(with detailProduct: DetailViewModelItem) {
        userNameLabel.text = detailProduct.userName
        nameLabel.text = detailProduct.name
        stockLabel.text = detailProduct.stock
        bargainPriceLabel.text = detailProduct.bargainPrice
        priceLabel.attributedText = detailProduct.price.strikeThrough()
        discountRateLabel.text = detailProduct.discountRate
        descriptionLabel.text = detailProduct.description
    }
    
    func setOwnerButtons(_ editButton: UIButton, _ deleteButton: UIButton) {
        editButton.snp.makeConstraints {
            $0.height.equalTo(30)
            $0.width.equalTo(editButton.snp.height)
        }
        
        deleteButton.snp.makeConstraints {
            $0.height.equalTo(30)
            $0.width.equalTo(deleteButton.snp.height)
        }
        
        userInformationStackView.addArrangedSubview(editButton)
        userInformationStackView.addArrangedSubview(deleteButton)
    }
    
    private func configureView() {
        addSubview(scrollView)
        scrollView.addSubview(imagesCollectionView)
        scrollView.addSubview(mainStackView)
        
        userInformationStackView.addArrangedSubview(userImageView)
        userInformationStackView.addArrangedSubview(userNameLabel)
        
        bargainStackView.addArrangedSubview(bargainPriceLabel)
        bargainStackView.addArrangedSubview(discountRateLabel)
        
        additionalStackView.addArrangedSubview(priceLabel)
        additionalStackView.addArrangedSubview(stockLabel)
        
        informationStackView.addArrangedSubview(bargainStackView)
        informationStackView.addArrangedSubview(additionalStackView)
        
        mainStackView.addArrangedSubview(userInformationStackView)
        mainStackView.addArrangedSubview(DividerLineView())
        mainStackView.addArrangedSubview(nameLabel)
        mainStackView.addArrangedSubview(informationStackView)
        mainStackView.addArrangedSubview(DividerLineView())
        mainStackView.addArrangedSubview(descriptionLabel)
        
        imagesCollectionView.register(
            DetailViewImagesCell.self,
            forCellWithReuseIdentifier: DetailViewImagesCell.identifier
        )
        
        imagesCollectionView.isPagingEnabled = true
    }
    
    private func configureConstraints() {
        userImageView.snp.makeConstraints {
            $0.height.equalTo(userNameLabel.snp.height).offset(8)
            $0.width.equalTo(userImageView.snp.height)
        }
        
        imagesCollectionView.snp.makeConstraints {
            $0.leading.top.trailing.equalToSuperview()
            $0.width.equalToSuperview()
            $0.height.equalTo(imagesCollectionView.snp.width)
            $0.bottom.equalTo(mainStackView.snp.top).offset(-16)
        }
        
        mainStackView.snp.makeConstraints {
            $0.leading.bottom.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview().offset(-20)
        }
        
        scrollView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}
