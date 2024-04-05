//
//  UserCardAssembly .swift
//  FakeNFT
//
//  Created by Глеб Капустин on 31.03.2024.
//

import UIKit

protocol StatisticsAssemblyBuilder {
    func build(with input: StatisticsInput, router: StatisticsRouter) -> UIViewController
}

final class StatisticsAssemblyBuilderImpl: StatisticsAssemblyBuilder {
    
    private let networkClient: NetworkClient
    
    init(networkClient: NetworkClient) {
        self.networkClient = networkClient
    }
    
    func build(with input: StatisticsInput, router: StatisticsRouter) -> UIViewController {
        var vc: UIViewController
        switch input {
        case .userDetailed(let userDetailed):
            vc = buildUserDetailedServiceImpl(with: userDetailed, router: router)
        case .nftIds(let nftIds):
            vc = buildUsersCollectionPresenterImpl(with: nftIds, router: router)
        }
        return vc
    }
    
    private func buildUserDetailedServiceImpl(with input: UserDetailed, router: StatisticsRouter) -> UIViewController {
        let presenter = UserCardPresenterImpl(
            userDetailed: input,
            router: router)
        let viewController = UserCardViewController(presenter: presenter)
        presenter.view = viewController
        return viewController
    }
    
    private func buildUsersCollectionPresenterImpl(with input: [String], router: StatisticsRouter) -> UIViewController {
        let presenter = UsersCollectionPresenterImpl(
            input: input,
            nftService: NftServiceImpl(networkClient: networkClient, storage: NftStorageImpl()),
            profileService: ProfileServiceImpl(networkClient: networkClient),
            cartService: CartServiceImpl(networkClient: networkClient),
            router: router
        )
        let viewController = UsersCollectionViewController(presenter: presenter)
        presenter.view = viewController
        return viewController
    }
}

