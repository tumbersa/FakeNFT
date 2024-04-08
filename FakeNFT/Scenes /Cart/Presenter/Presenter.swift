//
//  Presenter.swift
//  FakeNFT
//
//  Created by Марат Хасанов on 04.04.2024.
//

import UIKit

final class CartPresenter {
    private weak var view: CartView?
    var imageCache = NSCache<NSString, UIImage>()
    private let cartService: CartService
    private let nftService: NftService
    
    init(view: CartView, cartService: CartService, nftService: NftService) {
        self.view = view
        self.cartService = cartService
        self.nftService = nftService
    }
    
    func viewDidLoad() {
        view?.showLoader()
        loadCart(httpMethod: .get, model: Nft.self)
    }
    
    // Метод для кэширования изображений
    func cacheImages(for nfts: [Nft], completion: @escaping ([UIImage]) -> Void) {
        var cachedImages: [UIImage] = []
        for nft in nfts {
            for imageUrl in nft.images {
                if let cachedImage = imageCache.object(forKey: imageUrl.absoluteString as NSString) {
                    cachedImages.append(cachedImage)
                } else {
                    // Если изображение не найдено в кэше, пропускаем
                }
            }
        }
        completion(cachedImages)
    }
    
    // Метод для загрузки изображения по URL
    func loadImage(from imageUrl: URL, completion: @escaping (UIImage?) -> Void) {
        URLSession.shared.dataTask(with: imageUrl) { data, response, error in
            guard let data = data, error == nil else {
                print("Ошибка при загрузке изображения: \(error?.localizedDescription ?? "Unknown error")")
                completion(nil)
                return
            }
            if let image = UIImage(data: data) {
                completion(image)
            } else {
                print("Не удалось создать изображение из загруженных данных")
                completion(nil)
            }
        }.resume()
    }
    
    // Метод для кэширования загруженного изображения
    func cacheImage(_ image: UIImage, forKey key: String) {
        imageCache.setObject(image, forKey: key as NSString)
    }
    
    func loadCart(httpMethod: HttpMethod, model: Nft.Type) {
        cartService.loadCart(httpMethod: httpMethod, model: model as? Encodable) { [weak self] result in
            switch result {
            case .success(let cart):
                self?.loadNFTs(for: cart.nfts)
            case .failure(let error):
                self?.view?.hideLoader()
                self?.view?.displayError(error.localizedDescription)
            }
        }
    }
    
    private func loadNFTs(for ids: [String]) {
        var nfts: [Nft] = []
        let group = DispatchGroup()
        
        for id in ids {
            group.enter()
            nftService.loadNft(id: id) { result in
                defer { group.leave() }
                switch result {
                case .success(let nft):
                    nfts.append(nft)
                case .failure(let error):
                    print("Error loading NFT: \(error)")
                }
            }
        }
        
        group.notify(queue: .main) { [weak self] in
            self?.view?.hideLoader()
            if nfts.isEmpty {
                self?.view?.displayEmptyCart()
            } else {
                self?.view?.displayNFTs(nfts)
            }
        }
    }
    
    func deleteNFT(withId id: String) {
        // Implement delete NFT logic
    }
}
