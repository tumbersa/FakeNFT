//
//  CollectionViewController.swift
//  FakeNFT
//
//  Created by admin on 28.03.2024.
//

import UIKit

final class CollectionViewController: UIViewController {
    
    private let collectionLabelsFont = UIFont.systemFont(ofSize: 13, weight: .regular)
    private var collectionViewHeightConstraint = NSLayoutConstraint()
    
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
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = Asset.Colors.ypBlack.color
        label.font = UIFont.systemFont(ofSize: 22, weight: .bold)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var aboutAuthorLabel: UILabel = {
        let label = UILabel()
        label.textColor = Asset.Colors.ypBlack.color
        label.font = collectionLabelsFont
        label.text = L10n.Catalog.Collection.aboutAuthor
        label.translatesAutoresizingMaskIntoConstraints = false
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
    
    private lazy var backButton: UIBarButtonItem = {
        let button = UIBarButtonItem(image: UIImage(systemName: "chevron.backward"),
                                     style: .plain,
                                     target: self,
                                     action: #selector(backButtonTapped))
        return button
    }()
    
    private let coverImageHeight: CGFloat = 310
    
    private let collectionControllerSpacing: CGFloat = 16
    
    private let titleToAboutAuthorSpacing: CGFloat = 13
    
    private let aboutAuthorToAuthorLinkSpacing: CGFloat = 4
    
    private let aboutAuthorToDescriptionSpacing: CGFloat = 5
    
    private let descriptionToNftCollectionSpacing: CGFloat = 24
    
    private var collectionCellWidth: CGFloat = 0
    
    private var collectionOfMockNft: [MockNftStatistics] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setMockData()
        setupUI()
    }
    
    func setMockData() {
        collectionOfMockNft = [
            MockNftStatistics(name: "Archie", images: [Asset.MockImages.Peach.Archie._1.image], rating: 2, price: 1, id: "1"),
            MockNftStatistics(name: "Art", images: [Asset.MockImages.Peach.Art._1.image], rating: 3, price: 2, id: "2"),
            MockNftStatistics(name: "Biscuit", images: [Asset.MockImages.Peach.Biscuit._1.image], rating: 1, price: 3, id: "3"),
            MockNftStatistics(name: "Daisy", images: [Asset.MockImages.Peach.Daisy._1.image], rating: 4, price: 13, id: "4"),
            MockNftStatistics(name: "Nacho", images: [Asset.MockImages.Peach.Nacho._1.image], rating: 5, price: 4, id: "5"),
            MockNftStatistics(name: "Oreo", images: [Asset.MockImages.Peach.Oreo._1.image], rating: 2, price: 2, id: "6"),
            MockNftStatistics(name: "Pixi", images: [Asset.MockImages.Peach.Pixi._1.image], rating: 1, price: 1, id: "7"),
            MockNftStatistics(name: "Ruby", images: [Asset.MockImages.Peach.Ruby._1.image], rating: 3, price: 3, id: "8"),
            MockNftStatistics(name: "Susan", images: [Asset.MockImages.Peach.Susan._1.image], rating: 2, price: 41, id: "9"),
            MockNftStatistics(name: "Tater", images: [Asset.MockImages.Peach.Tater._1.image], rating: 2, price: 2, id: "10")
        ]
        
        coverImageView.image = Asset.MockImages.CollectionCovers.beige.image
        titleLabel.text = "Beige"
        authorLinkLabel.text = "Mock Link"
        collectionDescriptionLabel.text = "Персиковый — как облака над закатным солнцем в океане. В этой коллекции совмещены трогательная нежность и живая игривость сказочных зефирных зверей."
        
    }
    
    @objc private func authorLinkTapped() {
        
    }
    
    @objc private func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
}

//MARK: - UICollectionViewDataSource

extension CollectionViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        self.collectionCellWidth = calculateCellWidth(frameWidth: view.frame.width)
        calculateCollectionHeight(itemCount: collectionOfMockNft.count, cellHeight: self.collectionCellWidth * 1.78)
        return collectionOfMockNft.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NFTCollectionViewCellThreePerRow.reuseID,
                                                       for: indexPath) as? NFTCollectionViewCellThreePerRow else { 
            assertionFailure("не удалось получить NFTCollectionViewCellThreePerRow")
            return UICollectionViewCell() }
        
        cell.set(mockData: collectionOfMockNft[indexPath.row])
        return cell
    }
}

//MARK: - UICollectionViewDelegate

extension CollectionViewController: UICollectionViewDelegate {
    
}

//MARK: - UICollectionViewDelegateFlowLayout

extension CollectionViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionCellWidth, height: collectionCellWidth * 1.6)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        28
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        9
    }
}

//MARK: - UI config

private extension CollectionViewController {
    func setupUI() {
        configNavBackButton()
        addingViews()
        configConstraints()
        view.backgroundColor = Asset.Colors.ypWhite.color
    }
    
    func addingViews() {
        view.addSubview(scrollView)
        scrollView.addSubview(containerView)
        [ coverImageView,
          titleLabel,
          aboutAuthorLabel,
          authorLinkLabel,
          collectionDescriptionLabel,
          nftCollectionView
        ].forEach {containerView.addSubview($0)}
    }
    
    func configConstraints() {
        
        let safeArea = view.safeAreaLayoutGuide
        
        var topbarHeight: CGFloat {
                    return (navigationController?.view.window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0.0) +
                    (self.navigationController?.navigationBar.frame.height ?? 0.0)
                }
        
        collectionViewHeightConstraint = nftCollectionView.heightAnchor.constraint(equalToConstant: 0)
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor, constant: -topbarHeight),
            scrollView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor),
            
            containerView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            containerView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            containerView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            coverImageView.topAnchor.constraint(equalTo: containerView.topAnchor),
            coverImageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            coverImageView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            coverImageView.heightAnchor.constraint(equalToConstant: coverImageHeight),
            
            titleLabel.topAnchor.constraint(equalTo: coverImageView.bottomAnchor, constant: collectionControllerSpacing),
            titleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: collectionControllerSpacing),
            titleLabel.trailingAnchor.constraint(lessThanOrEqualTo: containerView.trailingAnchor),
            
            aboutAuthorLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: titleToAboutAuthorSpacing),
            aboutAuthorLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            
            authorLinkLabel.leadingAnchor.constraint(equalTo: aboutAuthorLabel.trailingAnchor, constant: aboutAuthorToAuthorLinkSpacing),
            authorLinkLabel.bottomAnchor.constraint(equalTo: aboutAuthorLabel.bottomAnchor),
            
            collectionDescriptionLabel.topAnchor.constraint(equalTo: aboutAuthorLabel.bottomAnchor, constant: aboutAuthorToDescriptionSpacing),
            collectionDescriptionLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            collectionDescriptionLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -collectionControllerSpacing),
            
            nftCollectionView.topAnchor.constraint(equalTo: collectionDescriptionLabel.bottomAnchor, constant: descriptionToNftCollectionSpacing),
            nftCollectionView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: collectionControllerSpacing),
            nftCollectionView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -collectionControllerSpacing),
            nftCollectionView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
            
            collectionViewHeightConstraint
        ])
    }
    
    private func calculateCollectionHeight(itemCount: Int, cellHeight: CGFloat) {
        let itemsPerRow = 3
        let bottomMargin: CGFloat = 40
        let numRows = (itemCount + itemsPerRow) / itemsPerRow // Вычисляем количество строк
        // Вычисляем высоту коллекции
        collectionViewHeightConstraint.constant = CGFloat(numRows) * cellHeight + bottomMargin
    }
    
    private func calculateCellWidth(frameWidth: CGFloat) -> CGFloat {
        let availableWidth = (frameWidth - (9 * 2 + 16 * 2))
        let itemWidth = availableWidth / 3
        return itemWidth
    }
    
    func configNavBackButton() {
        navigationController?.navigationBar.tintColor = Asset.Colors.ypBlack.color
        navigationItem.leftBarButtonItem = backButton
    }
}




