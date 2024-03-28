//
//  CollectionViewController.swift
//  FakeNFT
//
//  Created by admin on 28.03.2024.
//

import UIKit

final class CollectionViewController: UIViewController {
    
    private let collectionLabelsFont = UIFont.systemFont(ofSize: 13, weight: .light)
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = false
        scrollView.contentSize = CGSize(width: view.frame.width, height: view.frame.height)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    private lazy var containerView: UIView = {
        let containerView = UIView()
        containerView.translatesAutoresizingMaskIntoConstraints = false
        return containerView
    }()
    
    private lazy var coverImageView: UIImageView = {
        let image = UIImageView()
        image.layer.cornerRadius = 12
        image.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        image.image = Asset.MockImages.CollectionCovers.beige.image
        return image
    }()
    
    private lazy var aboutAuthorLabel: UILabel = {
        let label = UILabel()
        label.textColor = Asset.Colors.ypBlack.color
        label.font = collectionLabelsFont
        label.text = L10n.Catalog.Collection.aboutAuthor
        return label
    }()
    
    private lazy var authorLinkLabel: UILabel = {
        let label = UILabel()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(authorLinkTapped))
        label.font = collectionLabelsFont
        label.textColor = Asset.Colors.Universal.ypUniBlue.color
        label.backgroundColor = Asset.Colors.ypWhite.color
        label.translatesAutoresizingMaskIntoConstraints = false
        label.isUserInteractionEnabled = true
        label.addGestureRecognizer(tapGesture)
        return label
    }()
    
    private lazy var collectionDescriptionLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = collectionLabelsFont
        label.textColor = Asset.Colors.ypBlack.color
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var nftCollectionView: UICollectionView = {
        let nftCollection = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        nftCollection.isScrollEnabled = false
        nftCollection.dataSource = self
        nftCollection.delegate = self
        nftCollection.backgroundColor = Asset.Colors.ypWhite.color
        nftCollection.translatesAutoresizingMaskIntoConstraints = false
        nftCollection.register(NFTCollectionViewCellThreePerRow.self)
        return nftCollection
    }()
    
    @objc private func authorLinkTapped() {
        
    }
}

//MARK: - UICollectionViewDataSource

extension CollectionViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        <#code#>
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        <#code#>
    }
}

//MARK: - UICollectionViewDelegate

extension CollectionViewController: UICollectionViewDelegate {
    
}

extension CollectionViewController: UICollectionViewDelegateFlowLayout {
    
}


