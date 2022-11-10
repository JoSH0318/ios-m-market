//
//  ProductListCell.swift
//  MMarket
//
//  Created by 조성훈 on 2022/08/18.
//

import SnapKit

final class ProductListCell: UICollectionViewCell {
    
    private enum FontSize {
        static let title = 18.0
        static let subtitle = 16.0
        static let body = 12.0
    }
    
    static var idenfier: String {
        return String(describing: self)
    }
    
    private var imageDataTask: URLSessionDataTask?
    
    private let thumbnailImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.layer.cornerRadius = 4
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private let nameLabelStackView = UIStackView()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.font = .systemFont(ofSize: FontSize.title, weight: .bold)
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
    
    private let bargainInformationStackView = UIStackView()
    
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
        return label
    }()
    
    private let priceLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.font = .systemFont(ofSize: FontSize.body)
        label.textColor = .systemGray3
        return label
    }()
    
    private let totalInformationStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.setContentHuggingPriority(.init(rawValue: 1), for: .vertical)
        return stackView
    }()
    
    private let mainStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .equalCentering
        return stackView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureView()
        configureConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        CancelImageDownload()
        thumbnailImageView.image = nil
        nameLabel.text = nil
        stockLabel.text = nil
        discountRateLabel.text = nil
        priceLabel.attributedText = nil
        bargainPriceLabel.text = nil
    }
    
    func setContents(with viewModel: ProductListCellViewModel) {
        imageDataTask = thumbnailImageView.setImage(with: viewModel.thumbnailURL)
        nameLabel.text = viewModel.name
        stockLabel.text = viewModel.stock
        discountRateLabel.text = viewModel.discountRate
        priceLabel.attributedText = viewModel.price.strikeThrough()
        bargainPriceLabel.text = viewModel.bargainPrice
    }
    
    private func CancelImageDownload() {
        imageDataTask?.suspend()
        imageDataTask?.cancel()
    }
    
    private func configureView() {
        contentView.addSubview(thumbnailImageView)
        contentView.addSubview(mainStackView)
        
        nameLabelStackView.addArrangedSubview(nameLabel)
        nameLabelStackView.addArrangedSubview(discountRateLabel)
        
        bargainInformationStackView.addArrangedSubview(bargainPriceLabel)
        bargainInformationStackView.addArrangedSubview(stockLabel)
        
        totalInformationStackView.addArrangedSubview(bargainInformationStackView)
        totalInformationStackView.addArrangedSubview(priceLabel)
        
        mainStackView.addArrangedSubview(nameLabelStackView)
        mainStackView.addArrangedSubview(totalInformationStackView)
    }
    
    private func configureConstraints() {
        thumbnailImageView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(8)
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().offset(-16)
            $0.bottom.equalTo(mainStackView.snp.top).offset(-8)
            $0.width.equalTo(thumbnailImageView.snp.height)
        }
        
        mainStackView.snp.makeConstraints {
            $0.leading.equalTo(contentView).offset(24)
            $0.trailing.equalTo(contentView).offset(-24)
            $0.bottom.equalTo(contentView).offset(-8)
        }
    }
}
