//
//  UserService.swift
//  FakeNFT
//
//  Created by Глеб Капустин on 31.03.2024.
//

import Foundation

typealias UserDetailedCompletion = (Result<UserDetailed, Error>) -> Void

protocol UserDetailedService {
    func loadNft(id: String, completion: @escaping UserDetailedCompletion)
}

final class UserDetailedServiceImpl: UserDetailedService {

    private let networkClient: NetworkClient

    init(networkClient: NetworkClient) {
        self.networkClient = networkClient
    }

    func loadNft(id: String, completion: @escaping UserDetailedCompletion) {

        let request = UserDetailedBuildRequest(id: id)
        networkClient.send(request: request, type: UserDetailed.self) { result in
            switch result {
            case .success(let userDetailed):
                completion(.success(userDetailed))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
