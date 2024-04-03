//
//  UserCardViewPresenter.swift
//  FakeNFT
//
//  Created by Глеб Капустин on 31.03.2024.
//

import Foundation

protocol UserCardPresenter {
    func colletionNFTControlTapped()
    func websiteButtonTapped()
    func viewDidLoad()
}

final class UserCardPresenterImpl: UserCardPresenter {
    
    private let userId: String
    private let userDetailedService: UserDetailedService
    private let router: StatisticsRouter
    
    private(set) var userDetailed: UserDetailed?
    weak var view: UserCardView?
    
    init(userId: String, userDetailedService: UserDetailedService, router: StatisticsRouter) {
        self.userId = userId
        self.userDetailedService = userDetailedService
        self.router = router
    }
    
    func viewDidLoad() {
        UIBlockingProgressHUD.show()
        loadUserDetailed()
    }
    
    func colletionNFTControlTapped() {
        guard let userDetailed else { return }
        let userCollectionInput = StatisticsInput.nftIds(userDetailed.nfts)
        router.push(with: userCollectionInput)
    }
    
    func websiteButtonTapped() {
        guard let urlStr = userDetailed?.website else { return }
        router.presentSFViewController(urlStr: urlStr)
    }
    
    private func loadUserDetailed() {
        userDetailedService.loadUserDetailed(id: userId) { [weak self] result in
            UIBlockingProgressHUD.dismiss()
            guard let self else { return }
            
            switch result {
            case .success(let userDetailed):
                self.userDetailed = userDetailed
                view?.updateData(with: userDetailed)
            case .failure(_):
                view?.showError(ErrorModel() {[weak self] in
                    guard let self else { return }
                    viewDidLoad()
                })
            }
        }
    }
    
}
