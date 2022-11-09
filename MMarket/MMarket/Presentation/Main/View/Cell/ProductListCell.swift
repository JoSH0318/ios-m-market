//
//  ProductListCell.swift
//  MMarket
//
//  Created by 조성훈 on 2022/08/18.
//

import SnapKit

final class ProductListCell: UICollectionViewCell {
    
    private enum FontSize {
        static let title = 16.0
        static let body = 12.0
    }
    
    static var idenfier: String {
        return String(describing: self)
    }
    
    private let thumbnailImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.layer.cornerRadius = 4
        imageView.clipsToBounds = true
        return imageView
    }()
    
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
        return label
    }()
    
    private let totalPriceStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.setContentHuggingPriority(.init(rawValue: 1), for: .vertical)
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
        return stackView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func bind(with viewModel: ProductListCellViewModel) {
    func setContents(with viewModel: ProductListCellViewModel) {
        thumbnailImageView.setImage(with: viewModel.thumbnailURL)
        nameLabel.text = viewModel.name
        stockLabel.text = viewModel.stock
        discountRateLabel.text = viewModel.discountRate
        priceLabel.attributedText = viewModel.price.strikeThrough()
        bargainPriceLabel.text = viewModel.bargainPrice
    }
    
    private func configureLayout() {
        contentView.addSubview(thumbnailImageView)
        contentView.addSubview(totalStackView)

        thumbnailImageView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(8)
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().offset(-16)
            $0.bottom.equalTo(totalStackView.snp.top).offset(-8)
            $0.width.equalTo(thumbnailImageView.snp.height)
        }
        
        totalStackView.snp.makeConstraints {
            $0.leading.equalTo(contentView).offset(16)
            $0.bottom.trailing.equalTo(contentView).offset(-8)
        }
        
        bargainPriceStackView.addArrangedSubview(bargainPriceLabel)
        bargainPriceStackView.addArrangedSubview(discountRateLabel)
        totalPriceStackView.addArrangedSubview(bargainPriceStackView)
        totalPriceStackView.addArrangedSubview(priceLabel)
        
        totalStackView.addArrangedSubview(nameLabel)
        totalStackView.addArrangedSubview(totalPriceStackView)
//        totalStackView.addArrangedSubview(stockLabel)
    }
}
