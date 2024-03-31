//
//  UserCardViewPresenter.swift
//  FakeNFT
//
//  Created by Глеб Капустин on 31.03.2024.
//

import Foundation

protocol UserCardPresenter {
    func viewDidLoad()
    var userDetailed: UserDetailed? { get }
}

final class UserCardPresenterImpl: UserCardPresenter {
    
    private let userId: String
    private let userDetailedService: UserDetailedService
    
    private(set) var userDetailed: UserDetailed?
    weak var view: UserCardView?
    
    init(userId: String, userDetailedService: UserDetailedService) {
        self.userId = userId
        self.userDetailedService = userDetailedService
    }
    
    func viewDidLoad() {
        UIBlockingProgressHUD.show()
        loadUserDetailed()
    }
    
    func loadUserDetailed() {
        userDetailedService.loadUserDetailed(id: userId) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let userDetailed):
                self.userDetailed = userDetailed
                view?.updateData(with: userDetailed)
                UIBlockingProgressHUD.dismiss()
            case .failure(let error):
                print(error)
            }
        }
    }
    
}
