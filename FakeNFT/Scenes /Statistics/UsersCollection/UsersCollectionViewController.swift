//
//  StatisticsViewController.swift
//  FakeNFT
//
//  Created by Глеб Капустин on 24.03.2024.
//

import UIKit
import SnapKit

protocol UsersCollectionView: AnyObject, ErrorView {
    func updateData(on: [NftStatistics], id: String?, isCart: Bool?)
}

final class UsersCollectionViewController: UIViewController, ErrorView {
    
    private let presenter: UsersCollectionPresenter
    
    enum Section {
        case main
    }
    
    private lazy var dataSource: UICollectionViewDiffableDataSource<Section, NftStatistics> = {
        UICollectionViewDiffableDataSource<Section, NftStatistics>(
            collectionView: collectionView,
            cellProvider: {[weak self] (collectionView, indexPath, nft) -> UICollectionViewCell? in
                
                guard let self else { return UICollectionViewCell()}
                let cell: NFTCollectionViewCellThreePerRow = collectionView.dequeueReusableCell(indexPath: indexPath)
                let nftItem = presenter.arrOfNFT[indexPath.item]
                cell.set(data: nftItem)
                
                let idOfCell = nftItem.id
                cell.setLikedStateToLikeButton(isLiked: presenter.idLikes.contains(idOfCell))
                cell.setAddedStateToCart(isAdded: presenter.idAddedToCart.contains(idOfCell))
                cell.delegate = presenter
                
                return cell
            })
    }()
    
    private lazy var collectionView: UICollectionView! = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 8
        layout.sectionInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        layout.minimumInteritemSpacing = 9
        let availableWidth = (view.frame.width - (10 * 2 + 16 * 2))
        let itemWidth = availableWidth / 3
        layout.itemSize = CGSize(width: itemWidth, height: itemWidth * 1.78)
        
        let collectionView = UICollectionView(frame: view.frame, collectionViewLayout: layout)
        collectionView.register(NFTCollectionViewCellThreePerRow.self)
        
        return collectionView
    }()
    
    init(presenter: UsersCollectionPresenter) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureVC()
        configureCollectionView()
        presenter.viewDidLoad()
    }
    
    private func configureVC(){
       
        navigationController?.navigationBar.tintColor = .label
        title = "Коллекция NFT"
        view.backgroundColor = .systemBackground
        
        
        let backButton = UIBarButtonItem(title: "", 
                                         style: .plain,
                                         target: self,
                                         action: #selector(backButtonPressed))
        backButton.image = UIImage(systemName: "chevron.left")
        navigationItem.leftBarButtonItem = backButton
    }
    
    @objc private func backButtonPressed() {
        presenter.backButtonPressed()
    }
    
    private func configureCollectionView(){
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(20)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
    }
    
}

extension UsersCollectionViewController: UsersCollectionView {
    
    func updateData(on nfts: [NftStatistics], id: String?, isCart: Bool?) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, NftStatistics>()
        snapshot.appendSections([.main])
        snapshot.appendItems(nfts)
        
        
        self.dataSource.apply(snapshot, animatingDifferences: true)
        
        for (index, nft) in nfts.enumerated() {
            if let cell = self.collectionView.cellForItem(at: IndexPath(item: index, section: 0)) as? NFTCollectionViewCellThreePerRow {
                cell.set(data: nft)
                
                let idOfCell = nft.id
                cell.setLikedStateToLikeButton(isLiked: presenter.idLikes.contains(idOfCell))
                cell.setAddedStateToCart(isAdded: presenter.idAddedToCart.contains(idOfCell))
                
                if let id,
                   let isCart,
                   cell.getId() == id {
                    cell.setIsUserInteractionEnabledToTrue(isCart: isCart)
                }
                
                cell.delegate = presenter
            }
        }
        
    }
}
