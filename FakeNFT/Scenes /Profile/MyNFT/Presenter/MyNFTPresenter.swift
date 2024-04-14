//
//  MyNFTPresenter.swift
//  FakeNFT
//
//  Created by Dinara on 05.04.2024.
//

import Foundation

protocol MyNFTPresenterProtocol: AnyObject {
    var view: MyNFTViewControllerProtocol? { get set }
    func viewDidLoad()
}

final class MyNFTPresenter {
    weak var view: MyNFTViewControllerProtocol?
    private let profileNFTService = ProfileNFTService.shared
    var nfts: [NFT] = []
    var nftID: [String]
    var likedNFT: [String]
    private let editProfileService: EditProfileService

    init(nftID: [String], likedNFT: [String], editProfileService: EditProfileService) {
        self.nftID = nftID
        self.likedNFT = likedNFT
        self.editProfileService = editProfileService
    }

    func tapLike(id: String) {
        if likedNFT.contains(id) {
            likedNFT.removeAll(where: {$0 == id})
        } else {
            likedNFT.append(id)
        }
        updateLikes()
       
    }
}

extension MyNFTPresenter: MyNFTPresenterProtocol {
    func viewDidLoad() {
        fetchNFTs()
    }
}

private extension MyNFTPresenter {
    func fetchNFTs() {
        for id in nftID {
            profileNFTService.fetchNFTs(id) { [weak self] result in
                switch result {
                case .success(let nfts):
                    self?.view?.updateMyNFTs(nfts)
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
