//
//  StatisticsPresenter.swift
//  FakeNFT
//
//  Created by Глеб Капустин on 26.03.2024.
//

import Foundation

protocol StatisticsPresenter: AnyObject, NFTCollectionViewCellThreePerRowDelegate {
    func viewDidLoad()
    var arrOfNFT: [NftStatistics] { get }
    var idLikes: Set<String> { get }
    var idAddedToCart: Set<String> { get }
}

protocol NFTCollectionViewCellThreePerRowDelegate: AnyObject {
    func likeTapped(id: String)
    func cartTapped(id: String)
}

final class StatisticsPresenterImpl: StatisticsPresenter {
    let inputNftIds: [String]
    
    private let dispatchGroup = DispatchGroup()
    
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
    
    weak var view: StatisticsView?
    
    init(input: [String], nftService: NftService, profileService: ProfileService, cartService: CartService) {
        inputNftIds = input
        self.nftService = nftService
        self.profileService = profileService
        self.cartService = cartService
    }
    
    func viewDidLoad() {
        UIBlockingProgressHUD.show()
        
        
        dispatchGroup.enter()
        loadProfile(httpMethod: .get, completion: { [weak self] in
            guard let self else { return }
            dispatchGroup.leave()
        })
        
        dispatchGroup.enter()
        loadCart(httpMethod: .get, completion: { [weak self] in
            guard let self else { return }
            dispatchGroup.leave()
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
    
    private func loadProfile(httpMethod: HttpMethod, completion: @escaping () -> Void) {
        
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
            case .failure(let error):
                view?.showError(makeErrorModel(error))
            }
            completion()
        }
        
    }
    
    
    private func loadCart(httpMethod: HttpMethod, completion: @escaping () -> Void ) {
        
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
            case .failure(let error):
                view?.showError(makeErrorModel(error))
            }
            completion()
        }
        
    }
    
    private func makeErrorModel(_ error: Error) -> ErrorModel {
        let message: String
        switch error {
        case is NetworkClientError:
            message = NSLocalizedString("Error.network", comment: "")
        default:
            message = NSLocalizedString("Error.unknown", comment: "")
        }

        let actionText = "Ок"
        return ErrorModel(message: message, actionText: actionText) {
            print(error)
        }
    }
}


extension StatisticsPresenterImpl: NFTCollectionViewCellThreePerRowDelegate {
    func likeTapped(id: String) {
        
        idLikesForRequests = idLikes
        
        if idLikesForRequests.contains(id) {
            idLikesForRequests.remove(id)
        } else {
            idLikesForRequests.insert(id)
        }
        
        loadProfile(httpMethod: .put) { [weak self] in
            guard let self else { return }
            view?.updateData(on: arrOfNFT, id: id, isCart: false)
        }
    }
    
    func cartTapped(id: String) {
        
        idAddedToCartForRequests = idAddedToCart
        
        if idAddedToCartForRequests.contains(id) {
            idAddedToCartForRequests.remove(id)
        } else {
            idAddedToCartForRequests.insert(id)
        }
        
        loadCart(httpMethod: .put){ [weak self] in
            guard let self else { return }
            view?.updateData(on: arrOfNFT, id: id, isCart: true)
        }
    }
    
}
