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
    //переменная для хранения ID добавленных в корзину NFT
    private var idAddedToCart: Set<String> = []
    private let cartService: CartService
    private let nftService: NftService
    private var cartId: String = ""
    var arrOfNFT: [Nft] = [] {
        didSet {
            print("Добавился")
            view?.reloadTableView(nft: arrOfNFT)
        }
    }
    
    init(view: CartView, cartService: CartService, nftService: NftService) {
        self.view = view
        self.cartService = cartService
        self.nftService = nftService
    }
    
    func viewDidLoad() {
        view?.showLoader()
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
    
    func loadCart(httpMethod: HttpMethod, id: String? = nil, completion: @escaping (Error?) -> Void ) {
        cartService.loadCart(httpMethod: httpMethod, model: nil) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let cart):
                self.idAddedToCart = Set(cart.nfts)
                completion(nil)
                self.cartId = cart.id
            case .failure(let error):
                print(error)
                completion(error)
            }
        }
        view?.reloadTableView(nft: arrOfNFT)
    }
    
    func processNFTsLoading() {
        for id in idAddedToCart {
            loadNft(id: id)
        }
        view?.reloadTableView(nft: arrOfNFT)
        view?.hideLoader()
    }
    
    // Метод для загрузки NFT
    private func loadNft(id: String) {
        nftService.loadNft(id: id) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let nft):
                self.cacheImages(for: [nft]) { cachedImages in
                    // Действия с кэшированными изображениями
                }
                // Добавляем загруженный NFT в массив и обновляем представление
                self.arrOfNFT.append(nft)
                self.view?.reloadTableView(nft: arrOfNFT)
                DispatchQueue.main.async {
                    self.view?.reloadTableView(nft: self.arrOfNFT)
                }
            case .failure(let error):
                print(error)
            }
        }
        view?.reloadTableView(nft: arrOfNFT)
    }
    
    // Метод для кэширования загруженного изображения
    func cacheImage(_ image: UIImage, forKey key: String) {
        imageCache.setObject(image, forKey: key as NSString)
    }

    
    func deleteNFT(withId id: String) {
        // Implement delete NFT logic
    }
}
