//
//  FavoriteNFTPresenter.swift
//  FakeNFT
//
//  Created by Dinara on 09.04.2024.
//

import Foundation

protocol FavoriteNFTPresenterProtocol: AnyObject {
    var view: FavoriteNFTViewControllerProtocol? { get set }
    func viewDidLoad()
}

final class FavoriteNFTPresenter {
    weak var view: FavoriteNFTViewControllerProtocol?
    private let favoriteNFTService = FavoriteNFTService.shared
    var nftID: [String]
    var likedNFT: [String]
    var likes: [NFT] = []

    init(nftID: [String], likedNFT: [String]) {
        self.nftID = nftID
        self.likedNFT = likedNFT
    }
}

extension FavoriteNFTPresenter: FavoriteNFTPresenterProtocol {
    func viewDidLoad() {
        fetchFavoriteNFTs()
    }
}

private extension FavoriteNFTPresenter {
    func fetchFavoriteNFTs() {
        for id in likedNFT {
            favoriteNFTService.fetchNFTs(id) { [weak self] result in
                switch result {
                case .success(let likes):
                    self?.view?.updateFavoriteNFTs(likes)
                case .failure(let error):
                    print("Failed to fetch NFTs: \(error)")
                }
            }
        }
    }
}
