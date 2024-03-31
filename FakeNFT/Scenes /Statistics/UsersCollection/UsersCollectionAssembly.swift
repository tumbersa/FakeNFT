//
//  StatisticsAssenbly.swift
//  FakeNFT
//
//  Created by Глеб Капустин on 26.03.2024.
//

import UIKit

final class UsersCollectionAssembly {
    
    private let networkClient: NetworkClient
    
    init(networkClient: NetworkClient) {
        self.networkClient = networkClient
    }
    
    public func build(with input: [String]) -> UIViewController {
        let presenter = UsersCollectionPresenterImpl(
            input: input,
            nftService: NftServiceImpl(networkClient: networkClient, storage: NftStorageImpl()),
            profileService: ProfileServiceImpl(networkClient: networkClient),
            cartService: CartServiceImpl(networkClient: networkClient)
        )
        let viewController = UsersCollectionViewController(presenter: presenter)
        presenter.view = viewController
        return viewController
    }
}
