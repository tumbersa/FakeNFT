//
//  UserCardAssembly .swift
//  FakeNFT
//
//  Created by Глеб Капустин on 31.03.2024.
//

import UIKit

final class UserCardAssembly {
    
    private let networkClient: NetworkClient
    
    init(networkClient: NetworkClient) {
        self.networkClient = networkClient
    }
    
    public func build(with input: String) -> UIViewController {
        let presenter = UserCardPresenterImpl(
            userId: input,
            userDetailedService: UserDetailedServiceImpl(networkClient: networkClient))
        let viewController = UserCardViewController(presenter: presenter)
        presenter.view = viewController
        return viewController
    }
}

