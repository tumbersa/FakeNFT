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

    init(nftID: [String], likedNFT: [String]) {
        self.nftID = nftID
        self.likedNFT = likedNFT
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
                print("Ошибка: \(result)")
                switch result {
                case .success(let nfts):
                    self?.nfts.append(nfts)
                    self?.view?.updateMyNFTs(nfts)
                case .failure(let error):
                    print("Failed to fetch NFTs: \(error)")
                }
            }
        }
    }
}
