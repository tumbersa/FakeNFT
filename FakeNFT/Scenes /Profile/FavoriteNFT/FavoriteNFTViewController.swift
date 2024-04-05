//
//  FavoriteNFTViewController.swift
//  FakeNFT
//
//  Created by Dinara on 30.03.2024.
//

import SnapKit
import UIKit

// MARK: - FavoriteNFTViewController
final class FavoriteNFTViewController: UIViewController {

    // MARK: - Private Properties
    private var favoriteNFTS = [
        NFTCellModel(
            name: "Lilo",
            images: UIImage(named: "nft_icon") ?? UIImage(),
            rating: 3,
            price: 1.78,
            author: "John Doe",
            id: "1"
        ),
        NFTCellModel(
            name: "Lilo",
            images: UIImage(named: "nft_icon") ?? UIImage(),
            rating: 3,
            price: 1.78,
            author: "John Doe",
            id: "1"
        ),
        NFTCellModel(
            name: "Lilo",
            images: UIImage(named: "nft_icon") ?? UIImage(),
            rating: 3,
            price: 1.78,
            author: "John Doe",
            id: "1"
        ),
        NFTCellModel(
            name: "Lilo",
            images: UIImage(named: "nft_icon") ?? UIImage(),
            rating: 3,
            price: 1.78,
            author: "John Doe",
            id: "1"
        )
    ]

    // private var favoriteNFTS = [NFTCellModel]()
    // закомментируйте favoriteNFTS с моковыми данными и раскомментируйте строку выше для проверки верстки экрана отсутствия Моих NFT

    // MARK: - UI
    private lazy var navBackButton: UIBarButtonItem = {
        let button = UIBarButtonItem(
            image: UIImage(systemName: "chevron.backward"),
            style: .plain,
            target: self,
            action: #selector(navBackButtonDidTap))
        button.tintColor = UIColor(named: "ypBlack")
        return button
    }()

    private lazy var layout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let horizontalInset: CGFloat = 16
        let numberOfColumns: CGFloat = 2
        let minimumInterItemSpacing: CGFloat = 7
        let minimumLineSpacing: CGFloat = 20
        let totalHorizontalInset: CGFloat = horizontalInset * numberOfColumns + minimumInterItemSpacing
        let itemWidth: CGFloat = (view.frame.width - totalHorizontalInset) / numberOfColumns

        layout.minimumLineSpacing = minimumLineSpacing
        layout.minimumInteritemSpacing = minimumInterItemSpacing
        layout.estimatedItemSize = CGSize(width: itemWidth,
                                          height: view.frame.height)
        return layout
    }()

    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: layout
        )
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.showsVerticalScrollIndicator = false
        collectionView.backgroundColor = .systemBackground
        collectionView.register(FavoriteNFTCell.self,
                                forCellWithReuseIdentifier: FavoriteNFTCell.cellID)
        collectionView.clipsToBounds = false
        return collectionView
    }()

    private lazy var emptyLabel: UILabel = {
        let label = UILabel()
        label.text = L10n.Profile.emptyFavouriteNFT
        label.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        label.textColor = UIColor(named: "ypBlack")
        return label
    }()

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigation()
        setupViews()
        setupConstraints()
        updateEmptyView()
    }
}

// MARK: - Private Extension
private extension FavoriteNFTViewController {
    // MARK: - Setup Navigation
    func setupNavigation() {
        navigationItem.title = L10n.Profile.NFTFavorites
        navigationItem.leftBarButtonItem = navBackButton
    }

    // MARK: - Setup Views
    func setupViews() {
        [collectionView,
         emptyLabel
        ].forEach {
            view.addSubview($0)
        }
    }

    // MARK: - Setup Constraints
    func setupConstraints() {
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(20)
            make.bottom.equalTo(view.safeAreaLayoutGuide)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
        }

        emptyLabel.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
        }
    }

    func updateEmptyView() {
        if favoriteNFTS.isEmpty {
            self.emptyLabel.isHidden = false
            collectionView.isHidden = true
            navigationItem.title = ""
        } else {
            emptyLabel.isHidden = true
        }
    }

    // MARK: - Actions
    @objc func navBackButtonDidTap() {
        self.navigationController?.popViewController(animated: true)
    }
}

// MARK: - UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout
extension FavoriteNFTViewController: UICollectionViewDataSource,
                                     UICollectionViewDelegate,
                                     UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return favoriteNFTS.count
    }

    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: FavoriteNFTCell.cellID,
            for: indexPath
        ) as? FavoriteNFTCell else {
            fatalError("Could not cast to FavoriteNFTCell")
        }
        let favouriteNFT = favoriteNFTS[indexPath.row]
        cell.configureCell(with: favouriteNFT)
        cell.selectedBackgroundView = .none

        return cell
    }
}
