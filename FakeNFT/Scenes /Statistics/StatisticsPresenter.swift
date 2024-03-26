//
//  StatisticsPresenter.swift
//  FakeNFT
//
//  Created by Глеб Капустин on 26.03.2024.
//

import Foundation
import ProgressHUD

protocol StatisticsPresenter: AnyObject, NFTCollectionViewCellThreePerRowDelegate {
    func viewDidLoad()
    var arrOfNFT: [NftStatistics] { get }
    var idLikes: [String] { get }
    var idAddedToCart: [String] { get }
}

protocol NFTCollectionViewCellThreePerRowDelegate: AnyObject {
    func likeTapped(id: String)
    func cartTapped(id: String)
}

final class StatisticsPresenterImpl: StatisticsPresenter {
    let ids: [String]
    
    private var flagToFetchNft: Int = 0 {
        didSet {
            if flagToFetchNft == 2 {
                ProgressHUD.dismiss()
                for id in ids {
                    loadNft(id: id)
                }
            }
            if flagToFetchNft > 2 {
                view?.updateData(on: arrOfNFT)
            }
        }
    }
    
    private(set) var idLikes: [String] = []
    private(set) var idAddedToCart: [String] = []
    private var profile: Profile?
    private var cart: Cart?
    
    private(set) var arrOfNFT: [NftStatistics] = []
    
    private let networkClient: NetworkClient
    private lazy var service: NftService = NftServiceImpl(networkClient: networkClient, storage: NftStorageImpl())
    
    private lazy var profileService: ProfileService = ProfileServiceImpl(networkClient: DefaultNetworkClient())
    private lazy var cartService: CartService = CartServiceImpl(networkClient: DefaultNetworkClient())
    
    weak var view: StatisticsView?
    
    init(input: [String], networlClient: NetworkClient) {
        ids = input
        self.networkClient = networlClient
    }
    
    func viewDidLoad() {
        ProgressHUD.show()
        loadProfile(httpMethod: .get)
        loadCart(httpMethod: .get)
    }
    
    private func loadNft(id: String) {
        service.loadNft(id: id) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let nft):
                let nftStats = NftStatistics(
                    name: nft.name,
                    images: nft.images,
                    rating: nft.rating,
                    price: nft.price,
                    id: nft.id)
                arrOfNFT.append(nftStats)
                view?.updateData(on: arrOfNFT)
            case .failure(let error):
                print(error)
            }
        }
    }
    
    private func loadProfile(httpMethod: HttpMethod) {
        
        var formData: String?
        if let profile {
            let profileDTO = Profile(
                name: profile.name,
                avatar: profile.avatar,
                description: profile.description,
                website: profile.website,
                nfts: profile.nfts,
                likes: idLikes,
                id: profile.id
            )
            formData = profileDTO.toFormData()
        }
        
        profileService.loadProfile(httpMethod: httpMethod, model: formData) {[weak self] result in
            DispatchQueue.main.async { [weak self] in
                ProgressHUD.dismiss()
                switch result {
                case .success(let profile):
                    print(profile)
                    self?.profile = profile
                    self?.flagToFetchNft += 1
                    self?.idLikes = profile.likes
                case .failure(let error):
                    print(error)
                }
            }
        }
    }
    
    private func loadCart(httpMethod: HttpMethod) {
        
        var formData: String?
        if let cart {
            let cartDTO = Cart(
                nfts: idAddedToCart,
                id: cart.id)
            formData = cartDTO.toFormData()
        }
        
        cartService.loadCart(httpMethod: httpMethod, model: formData) {[weak self] result in
            DispatchQueue.main.async { [weak self] in
                ProgressHUD.dismiss()
                switch result {
                case .success(let cart):
                    print(cart)
                    self?.cart = cart
                    self?.flagToFetchNft += 1
                    self?.idAddedToCart = cart.nfts
                case .failure(let error):
                    
                    print(error)
                }
            }
        }
    }
}


extension StatisticsPresenterImpl: NFTCollectionViewCellThreePerRowDelegate {
    func likeTapped(id: String) {
        ProgressHUD.show()
        
        if idLikes.contains(id) {
            idLikes.removeAll(where: { $0 == id })
        } else {
            idLikes.append(id)
        }
        loadProfile(httpMethod: .put)
    }
    
    func cartTapped(id: String) {
        ProgressHUD.show()
        if idAddedToCart.contains(id) {
            idAddedToCart.removeAll(where: { $0 == id })
        } else {
            idAddedToCart.append(id)
        }
        loadCart(httpMethod: .put)
    }
    
}
