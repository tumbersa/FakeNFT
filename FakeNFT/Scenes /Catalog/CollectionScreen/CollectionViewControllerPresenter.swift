//
//  CollectionViewControllerPresenter.swift
//  FakeNFT
//
//  Created by admin on 06.04.2024.
//

import UIKit
import SafariServices
import ProgressHUD

final class CollectionViewControllerPresenter {
    
    weak var viewController: CollectionViewController?
    private var dataProvider: CollectionDataProviderProtocol
    private let dispatchGroup = DispatchGroup()
    private let utilityQueue = DispatchQueue.global(qos: .utility)
    
    let nftModel: NFTCatalogModel
    var authorURL: String = ""
    var nftArray: [Nft] = []
    private var profile: Profile?
    private var cart: Cart?
    
    private var idLikes: Set<String> = []
    private var idAddedToCart: Set<String> = []
    
    private var idLikesForRequests: Set<String> = []
    private var idAddedToCartForRequests: Set<String> = []
    
    private let nftService: NftService
    private let profileService: ProfileService
    private let cartService: CartService
    
    init(nftCatalogModel nftModel: NFTCatalogModel,
         dataProvider: CollectionDataProvider,
         nftService: NftService,
         profileService: ProfileService, 
         cartService: CartService) {
        self.nftModel = nftModel
        self.dataProvider = dataProvider
        self.nftService = nftService
        self.profileService = profileService
        self.cartService = cartService
    }
    
    func getLikesCartAndNft() {
        ProgressHUD.show()
        
        dispatchGroup.enter()
        loadProfile(httpMethod: .get, completion: { [weak self] error in
            guard let self else { return }
            dispatchGroup.leave()
            if error != nil { return }
        })
        
        dispatchGroup.enter()
        loadCart(httpMethod: .get, completion: { [weak self] error in
            guard let self else { return }
            dispatchGroup.leave()
            if error != nil { return }
        })
        
        dispatchGroup.notify(queue: .main) { [weak self] in
            guard let self else { return }
            processNFTsLoading()
            ProgressHUD.dismiss()
        }
        
        prepareFullDataForShow()
    }
    
    func isLiked(_ idOfCell: String) -> Bool {
        idLikes.contains(idOfCell)
    }
    
    func isAddedToCart(_ idOfCell: String) -> Bool {
        idAddedToCart.contains(idOfCell)
    }
    
    private func loadProfile(httpMethod: HttpMethod, id: String? = nil, completion: @escaping (Error?) -> Void) {

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
                    let errorModel = self.makeErrorModel(error, option: {
                        [weak self] in
                            guard let self else { return }
                            if let id {
                                likeTapped(id: id)
                            } else {
                                getLikesCartAndNft()
                            }
                    })
                    viewController?.showError(errorModel)
                    completion(error)
                }
            }
            
    }
    
    private func loadCart(httpMethod: HttpMethod, id: String? = nil, completion: @escaping (Error?) -> Void ) {
        
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
                let errorModel = self.makeErrorModel(error, option: {
                    [weak self] in
                        guard let self else { return }
                        if let id {
                            cartTapped(id: id)
                        } else {
                            getLikesCartAndNft()
                        }
                })
                viewController?.showError(errorModel)
                completion(error)
            }
        }
    }
    
    func prepareDataForShow(authorName: String) {
        let viewData = CollectionViewModel(coverImageURL: nftModel.cover,
                                           title: nftModel.name,
                                           description: nftModel.description,
                                           authorName: nftModel.author)
        viewController?.show(viewCollectionViewModel: viewData)
    }
    
    func prepareFullDataForShow() {
        let viewData = CollectionViewModel(coverImageURL: nftModel.cover,
                                           title: nftModel.name,
                                           description: nftModel.description,
                                           authorName: nftModel.author)
        viewController?.show(viewCollectionViewModel: viewData)
    }
    
    func loadAuthorWebsite() {
        authorURL = nftArray[0].author
    }
    
    func presentSFVC() {
        print(nftArray[0].author)
        if let url = URL(string: authorURL) {
            let safaryVC = SFSafariViewController(url: url)
            viewController?.configNavBackButton()
            viewController?.navigationController?.present(safaryVC, animated: true)
            viewController?.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        }
    }
    
    func backButtonTapped() {
        viewController?.navigationController?.popViewController(animated: true)
    }
    
    private func processNFTsLoading() {
        for id in nftModel.nfts {
            loadNftById(id: id)
        }
    }
    
    private func loadNftById(id: String) {
        nftService.loadNft(id: id) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let nft):
                nftArray.append(nft)
                loadAuthorWebsite()
                viewController?.reloadCollectionView()
            case .failure(let error):
                let errorModel = self.makeErrorModel(error, option: {self.loadNftById(id: id)})
                viewController?.showError(errorModel)
            }
        }
    }
}

//MARK: - NFTCollectionViewCellThreePerRowDelegate

extension CollectionViewControllerPresenter: NFTCollectionViewCellThreePerRowDelegate {
    func likeTapped(id: String) {
        
        idLikesForRequests = idLikes
        
        if idLikesForRequests.contains(id) {
            idLikesForRequests.remove(id)
        } else {
            idLikesForRequests.insert(id)
        }
        
        utilityQueue.async {[weak self] in
            self?.loadProfile(httpMethod: .put, id: id) { [weak self] _ in
                guard let self else { return }
                viewController?.reloadCollectionView()
              //  viewController?.updateData(with: nftArray, id: id, isCart: false)
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
            self?.loadCart(httpMethod: .put, id: id){ [weak self] _ in
                guard let self else { return }
                viewController?.reloadCollectionView()
              //  viewController?.updateData(with: nftArray, id: id, isCart: true)
            }
        }
    }
}

//MARK: - error handling

extension CollectionViewControllerPresenter {
    
    private func makeErrorModel(_ error: Error, option: (()->Void)?) -> ErrorModel {
        let message: String
        switch error {
        case is NetworkClientError:
            message = L10n.Error.network
        default:
            message = L10n.Error.unknown
        }

        let actionText = L10n.Error.repeat
        return ErrorModel(message: message, actionText: actionText) {
            if let option {
                option()
            }
        }
    }
    
    func showAlertController(alerts: [AlertModel]) {
        let alertController = UIAlertController(
            title: L10n.Catalog.sorting,
            message: nil,
            preferredStyle: .actionSheet)

        for alert in alerts {
            let action = UIAlertAction(title: alert.title, style: alert.style) { _ in
                if let completion = alert.completion {
                    completion()
                }
            }
            alertController.addAction(action)
        }
        guard let viewController = viewController else { return }
        viewController.present(alertController, animated: true)
    }
}
