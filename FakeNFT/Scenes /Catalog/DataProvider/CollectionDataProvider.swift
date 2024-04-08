//
//  CollectionDataProvider.swift
//  FakeNFT
//
//  Created by admin on 06.04.2024.
//

import Foundation
import ProgressHUD

protocol CollectionDataProviderProtocol: AnyObject {
    func getNFTCollectionAuthor(id: String, completion: @escaping CollectionCompletion)
    func loadNFTsBy(id: String, completion: @escaping NftCompletion)
    func updateUserProfile(with profile: Profile, completion: @escaping (Result<Data, Error>) -> Void)
    func getUserProfile(completion: @escaping ProfileCompletion)
    
}

typealias CollectionCompletion = (Result<UserDetailed, Error>) -> Void

//typealias ProfileCompletion = (Result<Profile, Error>) -> Void

final class CollectionDataProvider: CollectionDataProviderProtocol {
    
    let networkClient: DefaultNetworkClient
    var profile: Profile?
    
    init(networkClient: DefaultNetworkClient) {
        self.networkClient = networkClient
    }
    
    
    func getNFTCollectionAuthor(id: String, completion: @escaping CollectionCompletion) {
        ProgressHUD.show()
        networkClient.send(request: UserRequestById(id: id), type: UserDetailed.self) { result in
            switch result {
            case .success(let data):
                completion(.success(data))
            case .failure(let error):
                print(error.localizedDescription)
                completion(.failure(error))
            }
            ProgressHUD.dismiss()
        }
    }
    
    func loadNFTsBy(id: String, completion: @escaping NftCompletion) {
        ProgressHUD.show()
        networkClient.send(request: GetNFTById(id: id), type: Nft.self) { result in
            switch result {
            case .success(let data):
                completion(.success(data))
            case .failure(let error):
                completion(.failure(error))
            }
            ProgressHUD.dismiss()
        }
    }
    
    func updateUserProfile(with profile: Profile, completion: @escaping (Result<Data, Error>) -> Void) {
        networkClient.send(request: ProfileRequest(method: .put, model: profile)) { result in
            switch result {
            case .success(let data):
                completion(.success(data))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func getUserProfile(completion: @escaping ProfileCompletion) {
        ProgressHUD.show()
        networkClient.send(request: ProfileRequest(method: .get, model: .none), type: Profile.self) { result in
            switch result {
            case .success(let data):
                completion(.success(data))
            case .failure(let error):
                completion(.failure(error))
            }
            ProgressHUD.dismiss()
        }
    }
}

