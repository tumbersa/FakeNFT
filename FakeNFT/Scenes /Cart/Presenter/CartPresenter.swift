//
//  Presenter.swift
//  FakeNFT
//
//  Created by Марат Хасанов on 04.04.2024.
//

import UIKit
import SafariServices

final class CartPresenter {
    private weak var view: CartView?
    var imageCache = NSCache<NSString, UIImage>()
    
    private var idAddedToCart: Set<String> = []
    
    private let cartService: CartService
    private let nftService: NftService
    
    private var cartId: String = ""
    var arrOfNFT: [Nft] = [] {
        didSet {
            view?.reloadTableView(nft: arrOfNFT)
        }
    }
    
    init(view: CartView,
         cartService: CartService,
         nftService: NftService) {
        self.view = view
        self.cartService = cartService
        self.nftService = nftService
    }
    
    func viewDidLoad() {
        view?.showLoader()
    }
    
    func sortedNft() -> UIAlertController {
        let alertController = UIAlertController(title: "Сортировка", 
                                                message: nil,
                                                preferredStyle: .actionSheet)
        
        alertController.addAction(UIAlertAction(title: "По цене", 
                                                style: .default) { _ in
            self.arrOfNFT.sort { nftItem1, nftItem2 in
                nftItem1.price < nftItem2.price
            }
            self.view?.reloadTableView(nft: self.arrOfNFT)
        })
        
        
        alertController.addAction(UIAlertAction(title: "По рейтингу", 
                                                style: .default) { _ in
            self.arrOfNFT.sort { nftItem1, nftItem2 in
                nftItem1.rating > nftItem2.rating
            }
            self.view?.reloadTableView(nft: self.arrOfNFT)
        })
        
        
        alertController.addAction(UIAlertAction(title: "По названию", 
                                                style: .default) { _ in
            self.arrOfNFT.sort { nftItem1, nftItem2 in
                nftItem1.name < nftItem2.name
            }
            self.view?.reloadTableView(nft: self.arrOfNFT)
        })
        
        alertController.addAction(UIAlertAction(title: "Закрыть", 
                                                style: .cancel,
                                                handler: nil)
        )
        return alertController
    }
    
    private func cacheImages(for nfts: [Nft], 
                             completion: @escaping ([UIImage]) -> Void) {
        var cachedImages: [UIImage] = []
        for nft in nfts {
            for imageUrl in nft.images {
                if let cachedImage = imageCache.object(
                    forKey: imageUrl.absoluteString as NSString) {
                    cachedImages.append(cachedImage)
                }
            }
        }
        completion(cachedImages)
    }
    
    func loadImage(from imageUrl: URL, completion: @escaping (UIImage?) -> Void) {
        URLSession.shared.dataTask(with: imageUrl) { data, response, error in
            guard let data = data, error == nil else {
                completion(nil)
                return
            }
            if let image = UIImage(data: data) {
                completion(image)
            } else {
                completion(nil)
            }
        }.resume()
    }
    
    func loadCart(httpMethod: HttpMethod, id: String? = nil, 
                  completion: @escaping (Error?) -> Void ) {
        cartService.loadCart(httpMethod: httpMethod, model: nil) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let cart):
                self.idAddedToCart = Set(cart.nfts)
                completion(nil)
                self.cartId = cart.id
            case .failure(let error):
                completion(error)
            }
        }
    }
    
    func processNFTsLoading() {
        for id in idAddedToCart {
            loadNft(id: id)
        }
    }
    
    private func loadNft(id: String) {
        nftService.loadNft(id: id) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let nft):
                self.arrOfNFT.append(nft)
                self.view?.reloadTableView(nft: arrOfNFT)
            case .failure(let error):
                break
            }
        }
    }
    
    private func cacheImage(_ image: UIImage, forKey key: String) {
        imageCache.setObject(image, forKey: key as NSString)
    }
    
    func deleteNFT(at id: String, completion: @escaping () -> Void) {
        arrOfNFT.removeAll { $0.id == id }
        let newId = arrOfNFT.map { $0.id }
        
        self.cartService.updateOrder(nftsIds: newId, update: true) { error in
            if error != nil {
                return
            }
            completion()
        }
    }
}
