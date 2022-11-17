//
//  ImageButton.swift
//  MMarket
//
//  Created by 조성훈 on 2022/11/10.
//

import SnapKit

final class ImageButton: UIButton {
    private let mainStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.distribution = .equalCentering
        return stackView
    }()
    
    private let addImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "camera")
        imageView.tintColor = UIColor.grayColor
        return imageView
    }()
    
    private let imageCountLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12)
        label.textColor = UIColor.grayColor
        label.text = "0/5"
        return label
    }()
    
    init() {
        super.init(frame: .zero)
        
        configureView()
        configureConstraints()
        configureButton()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setLabelText(with count: Int) {
        imageCountLabel.text = String(count)
    }
    
    private func configureButton() {
        layer.borderWidth = 2
        layer.cornerRadius = 8
        layer.borderColor = UIColor.grayColor?.cgColor
        backgroundColor = .systemBackground
        clipsToBounds = true
    }
    
    private func configureView() {
        addSubview(mainStackView)
        mainStackView.addArrangedSubview(addImageView)
        mainStackView.addArrangedSubview(imageCountLabel)
    }
    
    private func configureConstraints() {
        mainStackView.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(10)
        }
        
        addImageView.snp.makeConstraints {
            $0.height.width.equalToSuperview().multipliedBy(0.5)
        }
    }
}
