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
    
    init(userId: String, userDetailedService: UserDetailedService) {
        self.userId = userId
        self.userDetailedService = userDetailedService
    }
    
    func viewDidLoad() {
        <#code#>
    }
    
    var userDetailed: UserDetailed?
    
    
}
