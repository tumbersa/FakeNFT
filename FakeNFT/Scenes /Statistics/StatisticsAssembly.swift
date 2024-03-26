//
//  StatisticsAssenbly.swift
//  FakeNFT
//
//  Created by Глеб Капустин on 26.03.2024.
//

import UIKit

public final class StatisticsAssembly {

    private let networkClient: NetworkClient

    init(networkClient: NetworkClient) {
        self.networkClient = networkClient
    }

    public func build(with input: [String]) -> UIViewController {
        let presenter = StatisticsPresenterImpl(input: input,networlClient: networkClient)
        let viewController = StatisticsViewController(presenter: presenter)
        presenter.view = viewController
        return viewController
    }
}
