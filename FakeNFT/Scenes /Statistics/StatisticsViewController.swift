//
//  StatisticsViewController.swift
//  FakeNFT
//
//  Created by Глеб Капустин on 24.03.2024.
//

import UIKit

protocol NFTCollectionViewCellThreePerRowDelegate: AnyObject {
    func likeTapped(isLiked: Bool)
    func cartTapped(isAdded: Bool)
}

final class StatisticsViewController: UIViewController {
    
    let ids: [String] =
    ["e8c1f0b6-5caf-4f65-8e5b-12f4bcb29efb",
     "1fda6f0c-a615-4a1a-aa9c-a1cbd7cc76ae",
     "b3907b86-37c4-4e15-95bc-7f8147a9a660",
     "de7c0518-6379-443b-a4be-81f5a7655f48",
     "ca9130a1-8ec6-4a3a-9769-d6d7958b90e3",
     "c14cf3bc-7470-4eec-8a42-5eaa65f4053c",
     "7773e33c-ec15-4230-a102-92426a3a6d5a",
     "82570704-14ac-4679-9436-050f4a32a8a0"
    ]
    
    let idLikes: [String] = []
    //TODO: - перенести в presenter
    private var arrOfNFT: [NftStatistics] = []
    
    private let service: NftService = NftServiceImpl(networkClient: DefaultNetworkClient(), storage: NftStorageImpl())
    
    private let profileService: ProfileService = ProfileServiceImpl(networkClient: DefaultNetworkClient())
    private let cartService: CartService = CartServiceImpl(networkClient: DefaultNetworkClient())
    
    private lazy var collectionView: UICollectionView! = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 8
        layout.sectionInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        layout.minimumInteritemSpacing = 9
        let availableWidth = (view.frame.width - (9 * 2 + 16 * 2))
        let itemWidth = availableWidth / 3
        layout.itemSize = CGSize(width: itemWidth, height: itemWidth * 1.78)
        let collectionView = UICollectionView(frame: view.frame, collectionViewLayout: layout)
        
        return collectionView
    }()
    
    let cell = NFTCollectionViewCellThreePerRow(frame: .zero)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        for id in ids {
            loadNft(id: id)
        }
        
        title = "Коллекции NFT"
        view.backgroundColor = .systemBackground
        
        view.addSubview(collectionView)
        collectionView.dataSource = self
        collectionView.register(NFTCollectionViewCellThreePerRow.self, forCellWithReuseIdentifier: NFTCollectionViewCellThreePerRow.reuseID)
        
        loadProfile(httpMethod: .get)
        
        loadCart(httpMethod: .put)
    }
    
    private func loadNft(id: String) {
        service.loadNft(id: id) { [weak self] result in
            switch result {
            case .success(let nft):
                let nftStats = NftStatistics(
                    name: nft.name,
                    images: nft.images,
                    rating: nft.rating,
                    price: nft.price)
                self?.arrOfNFT.append(nftStats)
                self?.collectionView.reloadData()
            case .failure(let error):
                print(error)
            }
        }
    }
    
    private func loadProfile(httpMethod: HttpMethod) {
        let profile = Profile(name: "Francisca Bowers",
                            avatar: URL(string: "https://cloudflare-ipfs.com/ipfs/Qmd3W5DuhgHirLHGVixi6V76LhCkZUz6pnFt5AJBiyvHye/avatar/154.jpg")!,
                            description: "milk cassete",
                            website: URL(string: "https://student16.students.practicum.org")!,
                            nfts: ["e8c1f0b6-5caf-4f65-8e5b-12f4bcb29efb", "1fda6f0c-a615-4a1a-aa9c-a1cbd7cc76ae", "b3907b86-37c4-4e15-95bc-7f8147a9a660", "de7c0518-6379-443b-a4be-81f5a7655f48", "ca9130a1-8ec6-4a3a-9769-d6d7958b90e3", "c14cf3bc-7470-4eec-8a42-5eaa65f4053c", "7773e33c-ec15-4230-a102-92426a3a6d5a", "82570704-14ac-4679-9436-050f4a32a8a0"],
                            likes: ["e8c1f0b6-5caf-4f65-8e5b-12f4bcb29efb", "1fda6f0c-a615-4a1a-aa9c-a1cbd7cc76ae"],
                            id: "6209b976-c7aa-4061-8574-573765a55e71")

        let formData = profile.toFormData()
        profileService.loadProfile(httpMethod: httpMethod, model: formData) { result in
            switch result {
            case .success(let profile):
                print(profile)
            case .failure(let error):
                print(error)
            }
        }
    }
    
    private func loadCart(httpMethod: HttpMethod) {
        let model = Cart(
            nfts: ["b3907b86-37c4-4e15-95bc-7f8147a9a660",
                   "de7c0518-6379-443b-a4be-81f5a7655f48"],
            id: "78604c31-077c-4417-bcee-88e1b06ecce1")
        let dto = model.toFormData()
        
        cartService.loadCart(httpMethod: httpMethod, model: dto) { result in
            switch result {
            case .success(let cart):
                print(cart)
                
            case .failure(let error):
                print(error)
            }
        }
    }
}

extension StatisticsViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        arrOfNFT.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NFTCollectionViewCellThreePerRow.reuseID, for: indexPath) as! NFTCollectionViewCellThreePerRow
        cell.set(data: arrOfNFT[indexPath.item])
        return cell
    }
}



