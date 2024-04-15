//
//  PayNftPresenter.swift
//  FakeNFT
//
//  Created by Марат Хасанов on 09.04.2024.
//

import Foundation
import SafariServices

final class PayNftPresenter {
    private weak var view: PayNftView?
    var imageCache = NSCache<NSString, UIImage>()
    
    
    let servicesAssembly: ServicesAssembly
    
    init(servicesAssembly: ServicesAssembly) {
        self.servicesAssembly = servicesAssembly
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func showSafariView() -> SFSafariViewController {
        let urlString = "https://yandex.ru/legal/practicum_termsofuse/"
        guard let url = URL(string: urlString) else { fatalError("Invalid URL") }
        let vc = SFSafariViewController(url: url)
        return vc
    }
    
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
    
    
    func cacheImages(for nfts: [Nft], completion: @escaping ([UIImage]) -> Void) {
        var cachedImages: [UIImage] = []
        for nft in nfts {
            for imageUrl in nft.images {
                if let cachedImage = imageCache.object(forKey: imageUrl.absoluteString as NSString) {
                    cachedImages.append(cachedImage)
                }
            }
        }
        completion(cachedImages)
    }
    
    func paymentConfirmationRequest(selectedCrypto: String, allPaymentNft: [Nft], completion: @escaping (UIViewController?) -> Void) {
        servicesAssembly.nftService.paymentConfirmationRequest() { result in
            switch result {
            case .success(let getOrder):
                if getOrder.success, getOrder.id == selectedCrypto {
                    let vc = CongratulationViewController()
                    vc.allPaymentNft = allPaymentNft
                    vc.modalPresentationStyle = .fullScreen
                    completion(vc)
                } else {
                    completion(nil)
                }
            case .failure:
                completion(nil)
            }
        }
    }
    
    func loadCurrencyList(completion: @escaping ([Currency]?, Error?) -> Void) {
        servicesAssembly.nftService.loadCurrencyList { result in
            switch result {
            case .success(let currencies):
                completion(currencies, nil)
            case .failure(let error):
                print("Ошибка при загрузке списка валют: \(error)")
                completion(nil, error)
            }
        }
    }
}
