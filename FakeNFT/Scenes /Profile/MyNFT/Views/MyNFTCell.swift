//
//  MyNFTCell.swift
//  FakeNFT
//
//  Created by Dinara on 28.03.2024.
//

import SnapKit
import UIKit

// MARK: - MyNFTCell
final class MyNFTCell: UITableViewCell {
    // MARK: - Public properties
    public static let cellID = String(describing: MyNFTCell.self)

    // MARK: - UI
    private lazy var image: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 12
        imageView.layer.masksToBounds = true
        return imageView
    }()

    private lazy var favoriteButton: UIButton = {
        let button = UIButton()
        button.setImage(
            UIImage(named: "favorite_button_inactive"),
            for: .normal
        )
        button.addTarget(
            self,
            action: #selector(self.favoriteButtonDidTap),
            for: .touchUpInside)
        return button
    }()

    private lazy var name: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        label.textColor = UIColor(named: "ypBlack")
        return label
    }()

    private lazy var rating: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()

    private lazy var author: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        label.textColor = UIColor(named: "ypBlack")
        return label
    }()

    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .equalSpacing
        stackView.alignment = .leading
        stackView.spacing = 4
        return stackView
    }()

    private lazy var priceLabel: UILabel = {
        let label = UILabel()
        label.text = L10n.Profile.priceText
        label.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        label.textColor = UIColor(named: "ypBlack")
        return label
    }()

    private lazy var priceValue: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        label.textColor = UIColor(named: "ypBlack")
        return label
    }()

    private lazy var priceStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .equalSpacing
        stackView.alignment = .leading
        stackView.spacing = 2
        return stackView
    }()

    override init(
        style: UITableViewCell.CellStyle,
        reuseIdentifier: String?
    ) {
        super.init(
            style: style,
            reuseIdentifier: reuseIdentifier
        )
        setupViews()
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Public Method
    func configureCell(with model: NFTCellModel) {
        image.image = model.image
        name.text = model.name
        rating.image = model.rating
        author.text = model.author
        priceValue.text = model.price
    }
 }

private extension MyNFTCell {
    func setupViews() {
        self.backgroundColor = .systemBackground

        [name,
         rating,
         author
        ].forEach {
            stackView.addArrangedSubview($0)
        }

        [priceLabel,
         priceValue
        ].forEach {
            priceStackView.addArrangedSubview($0)
        }

        [image,
         favoriteButton,
         stackView,
         priceStackView
        ].forEach {
            self.addSubview($0)
        }
    }

    func setupConstraints() {
        image.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(16)
            make.leading.equalToSuperview().offset(16)
            make.centerY.equalToSuperview()
            make.size.equalTo(108)
        }

        favoriteButton.snp.makeConstraints { make in
            make.top.equalTo(image.snp.top).offset(12)
            make.trailing.equalTo(image.snp.trailing).offset(-12)
            make.width.equalTo(18)
            make.height.equalTo(16)
        }

        stackView.snp.makeConstraints { make in
            make.centerY.equalTo(image.snp.centerY)
            make.leading.equalTo(image.snp.trailing).offset(20)
            make.bottom.equalTo(image.snp.bottom).offset(-23)
        }

        priceStackView.snp.makeConstraints { make in
            make.centerY.equalTo(stackView.snp.centerY)
            make.trailing.equalToSuperview().offset(-39)
            make.bottom.equalTo(stackView.snp.bottom).offset(-10)
        }
    }

    // MARK: - Actions
    @objc func favoriteButtonDidTap() {
        print("Favorite button did tap")
    }
}
