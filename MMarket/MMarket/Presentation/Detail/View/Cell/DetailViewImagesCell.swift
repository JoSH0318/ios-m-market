//
//  DetailViewImagesCell.swift
//  MMarket
//
//  Created by 조성훈 on 2022/11/02.
//

import SnapKit
import RxSwift

final class DetailViewImagesCell: UICollectionViewCell {
    
    private enum FontSize {
        static let title = 16.0
        static let body = 12.0
    }
    
    static var identifier: String {
        return String(describing: self)
    }
    
    private var viewModel: DetailViewImagesCellModel?
    private let disposeBag = DisposeBag()
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = .systemGray6
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func bind(with imageURL: String) {
        viewModel = DetailViewImagesCellModel(imageURL: imageURL)
        
        viewModel?.productImage
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] image in
                self?.imageView.image = image
            })
            .disposed(by: disposeBag)
    }
    
    private func configureLayout() {
        contentView.addSubview(imageView)
        
        imageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}
