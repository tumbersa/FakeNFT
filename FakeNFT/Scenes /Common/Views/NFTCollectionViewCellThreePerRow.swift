//
//  NFTCollectionViewCellThreePerRow.swift
//  FakeNFT
//
//  Created by Глеб Капустин on 24.03.2024.
//

import UIKit
import SnapKit
import Kingfisher

final class NFTCollectionViewCellThreePerRow: UICollectionViewCell {
    
    static let reuseID = "NFTCollectionViewCellThreePerRow"
    
    private lazy var nftImageView: UIImageView = {
        let nftImageView = UIImageView()
        nftImageView.layer.cornerRadius = 12
        nftImageView.layer.masksToBounds = true
        nftImageView.image = Asset.MockImages.Beige.April._1.image
        nftImageView.translatesAutoresizingMaskIntoConstraints = false
        return nftImageView
    }()
    
    private lazy var likeButton: UIButton = {
        let likeButton = UIButton()
        likeButton.setImage(
            UIImage(systemName: "heart.fill"),
            for: .normal)
        likeButton.tintColor = .white
        likeButton.translatesAutoresizingMaskIntoConstraints = false
        return likeButton
    }()
    
    private lazy var ratingStackView: RatingStackView = RatingStackView()
    private lazy var bottomContainerView = UIView()
    
    private lazy var nameLabel: UILabel = {
        let nameLabel = UILabel()
        nameLabel.font = .bodyBold
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.text = "Archie"
        #warning("Проверить нужно ли уменьшать текст")
        nameLabel.setContentCompressionResistancePriority(.required, for: .vertical)
        nameLabel.numberOfLines = 2
        nameLabel.adjustsFontSizeToFitWidth = true
        return nameLabel
    }()
    
    private lazy var priceLabel: UILabel = {
        let priceLabel = UILabel()
        priceLabel.translatesAutoresizingMaskIntoConstraints = false
        priceLabel.font = .systemFont(ofSize: 10, weight: .medium)
        priceLabel.text = "1,78 ETH"
        return priceLabel
    }()
    
    private lazy var cartImageView: UIImageView = {
        let cartImageView = UIImageView(image: UIImage(resource: .cartAdd))
        cartImageView.translatesAutoresizingMaskIntoConstraints = false
        cartImageView.contentMode = .scaleAspectFit
        return cartImageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        layoutUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func layoutUI() {
        contentView.addSubview(nftImageView)
        nftImageView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.height.equalTo(contentView.snp.width)
        }
        
        nftImageView.addSubview(likeButton)
        likeButton.snp.makeConstraints { make in
            make.height.equalTo(40)
            make.width.equalTo(40)
            make.trailing.equalToSuperview()
            make.top.equalToSuperview()
        }
        
        ratingStackView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(ratingStackView)
        ratingStackView.snp.makeConstraints { make in
            make.top.equalTo(nftImageView.snp.bottom).offset(8)
            make.leading.equalToSuperview()
            make.trailing.equalTo(nftImageView.snp.trailing).offset(-40)
        }
        
        bottomContainerView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(bottomContainerView)
        bottomContainerView.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.top.equalTo(ratingStackView.snp.bottom).offset(5)
            make.trailing.equalToSuperview()
            make.bottom.greaterThanOrEqualToSuperview().offset(-21)
        }
        
        bottomContainerView.addSubview(cartImageView)
        cartImageView.snp.makeConstraints { make in
            make.trailing.equalToSuperview()
            make.centerY.equalToSuperview()
            make.width.equalTo(40)
        }
        
        bottomContainerView.addSubview(nameLabel)
        nameLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.top.equalToSuperview()
            make.trailing.equalTo(cartImageView.snp.leading)
        }
        
        bottomContainerView.addSubview(priceLabel)
        priceLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.bottom.equalToSuperview()
            make.top.equalTo(nameLabel.snp.bottom).offset(4)
            make.trailing.equalTo(cartImageView.snp.leading)
        }
        
    }
    
    func set(data: NftStatistics) {
        nftImageView.kf.setImage(with: data.images[0])
        nameLabel.text = data.name
        ratingStackView.set(rating: data.rating)
        let numStr = String(format: "%.2f", data.price)
        priceLabel.text = numStr + " ETH"
    }
}

@available(iOS 17.0, *)
#Preview {
    NFTCollectionViewCellThreePerRow(frame: .zero)
}
