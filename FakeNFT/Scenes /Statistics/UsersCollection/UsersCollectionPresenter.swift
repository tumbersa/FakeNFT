//
//  StatisticsPresenter.swift
//  FakeNFT
//
//  Created by Глеб Капустин on 26.03.2024.
//

import Foundation

protocol UsersCollectionPresenter: AnyObject, NFTCollectionViewCellThreePerRowDelegate {
    func viewDidLoad()
    var arrOfNFT: [NftStatistics] { get }
    var idLikes: Set<String> { get }
    var idAddedToCart: Set<String> { get }
}

protocol NFTCollectionViewCellThreePerRowDelegate: AnyObject {
    func likeTapped(id: String)
    func cartTapped(id: String)
}

final class UsersCollectionPresenterImpl: UsersCollectionPresenter {
    let inputNftIds: [String]
    
    private let dispatchGroup = DispatchGroup()
    private let utilityQueue = DispatchQueue.global(qos: .utility)
    
    private(set) var idLikes: Set<String> = []
    private(set) var idAddedToCart: Set<String> = []
    
    private var idLikesForRequests: Set<String> = []
    private var idAddedToCartForRequests: Set<String> = []
    
    private var profile: Profile?
    private var cart: Cart?
    
    private(set) var arrOfNFT: [NftStatistics] = []
    
    private let nftService: NftService
    private let profileService: ProfileService
    private let cartService: CartService
    
    weak var view: UsersCollectionView?
    
    init(input: [String], nftService: NftService, profileService: ProfileService, cartService: CartService) {
        inputNftIds = input
        self.nftService = nftService
        self.profileService = profileService
        self.cartService = cartService
    }
    
    func viewDidLoad() {
        UIBlockingProgressHUD.show()
        
        dispatchGroup.enter()
        loadProfile(httpMethod: .get, completion: { [weak self] error in
            guard let self else { return }
            dispatchGroup.leave()
            if let error { return }
        })
        
        dispatchGroup.enter()
        loadCart(httpMethod: .get, completion: { [weak self] error in
            guard let self else { return }
            dispatchGroup.leave()
            if let error { return }
        })
        
        dispatchGroup.notify(queue: .main) { [weak self] in
            guard let self else { return }
            processNFTsLoading()
            UIBlockingProgressHUD.dismiss()
        }
        
    }
    
    private func processNFTsLoading() {
        for id in inputNftIds {
            loadNft(id: id)
        }
    }
    
    private func loadNft(id: String) {
        nftService.loadNft(id: id) { [weak self] result in
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
                view?.updateData(on: arrOfNFT, id: nil, isCart: nil)
            case .failure(let error):
                print(error)
            }
        }
    }
    
    private func loadProfile(httpMethod: HttpMethod, completion: @escaping (Error?) -> Void) {
        
        var formData: String = ""
        if let profile {
            let profileDTO = Profile(
                name: profile.name,
                avatar: profile.avatar,
                description: profile.description,
                website: profile.website,
                nfts: profile.nfts,
                likes: Array(idLikesForRequests),
                id: profile.id
            )
            formData = profileDTO.toFormData()
        }
        
        profileService.loadProfile(httpMethod: httpMethod, model: formData) {[weak self] result in
            guard let self else { return }
            switch result {
            case .success(let profile):
                self.profile = profile
                idLikes = Set(profile.likes)
                completion(nil)
            case .failure(let error):
                print(error)
                view?.showError(ErrorModel() {[weak self] in
                    guard let self else { return }
                    if let id = idLikes.symmetricDifference(idLikesForRequests).first {
                        likeTapped(id: id)
                    } else {
                        viewDidLoad()
                    }
                })
                completion(error)
            }
        }
        
    }
    
    
    private func loadCart(httpMethod: HttpMethod, completion: @escaping (Error?) -> Void ) {
        
        var formData: String = ""
        if let cart {
            let cartDTO = Cart(
                nfts: Array(idAddedToCartForRequests),
                id: cart.id)
            formData = cartDTO.toFormData()
        }
        
        cartService.loadCart(httpMethod: httpMethod, model: formData) {[weak self] result in
            guard let self else { return }
            switch result {
            case .success(let cart):
                self.cart = cart
                idAddedToCart = Set(cart.nfts)
                completion(nil)
            case .failure(let error):
                print(error)
                view?.showError(ErrorModel() {[weak self] in
                    guard let self else { return }
                    if let id = idAddedToCart.symmetricDifference(idAddedToCartForRequests).first {
                        cartTapped(id: id)
                    } else {
                        viewDidLoad()
                    }
                })
                completion(error)
            }
        }
        
    }
}


extension UsersCollectionPresenterImpl: NFTCollectionViewCellThreePerRowDelegate {
    func likeTapped(id: String) {
        
        idLikesForRequests = idLikes
        
        if idLikesForRequests.contains(id) {
            idLikesForRequests.remove(id)
        } else {
            idLikesForRequests.insert(id)
        }
        
        utilityQueue.async {[weak self] in
            self?.loadProfile(httpMethod: .put) { [weak self] error in
                if let error { return }
                guard let self else { return }
                view?.updateData(on: arrOfNFT, id: id, isCart: false)
            }
        }
    }
    
    func cartTapped(id: String) {
        
        idAddedToCartForRequests = idAddedToCart
        
        if idAddedToCartForRequests.contains(id) {
            idAddedToCartForRequests.remove(id)
        } else {
            idAddedToCartForRequests.insert(id)
        }
        
                
        utilityQueue.async {[weak self] in
            self?.loadCart(httpMethod: .put){ [weak self] error in
                if let error { return }
                guard let self else { return }
                view?.updateData(on: arrOfNFT, id: id, isCart: true)
            }
        }
        
    }
    
}
