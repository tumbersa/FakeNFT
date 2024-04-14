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
    private let editProfileService: EditProfileService

    init(nftID: [String], likedNFT: [String], editProfileService: EditProfileService) {
        self.nftID = nftID
        self.likedNFT = likedNFT
        self.editProfileService = editProfileService
    }

    func tapLikeNFT(for nft: NFT) {
        if let index = likedNFT.firstIndex(of: nft.id) {
            likedNFT.remove(at: index)
            likes.removeAll { $0.id == nft.id }
        } else {
            likedNFT.append(nft.id)
            likes.append(nft)
        }
        updateLikes()
        view?.updateFavoriteNFTs(likes)
    }

    func isLiked(id: String) -> Bool {
        return likedNFT.contains(id)
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

    func updateLikes() {
        let model = EditProfileModel(
            name: nil,
            description: nil,
            website: nil,
            likes: likedNFT
        )

        editProfileService.updateProfile(with: model) { result in
            switch result {
            case .success:
                print("Успешно")
            case .failure(let error):
                print("\(error.localizedDescription)")
            }
        }
    }
}
