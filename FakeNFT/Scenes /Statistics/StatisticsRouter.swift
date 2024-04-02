//
//  StatisticsRouter.swift
//  FakeNFT
//
//  Created by Глеб Капустин on 02.04.2024.
//

import UIKit

protocol StatisticsRouter {
    func push(with input: StatisticsInput)
    func pop()
}

final class StatisticsRouterImpl: StatisticsRouter {
    private let navigationController: UINavigationController?
    private let assemblyBuilder: StatisticsAssemblyBuilder?
    
    init(navigationController: UINavigationController?, assemblyBuilder: StatisticsAssemblyBuilder?) {
        self.navigationController = navigationController
        self.assemblyBuilder = assemblyBuilder
    }
    
    func initialViewController(input: StatisticsInput) {
        guard let assemblyBuilder else { return }
        let vc = assemblyBuilder.build(with: input, router: self)
        navigationController?.viewControllers = [vc]
    }
    
    func push(with input: StatisticsInput) {
        guard let assemblyBuilder else { return }
        let vc = assemblyBuilder.build(with: input, router: self)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func pop() {
        navigationController?.popViewController(animated: true)
    }
}

