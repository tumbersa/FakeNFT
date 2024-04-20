//
//  ProfileService.swift
//  FakeNFT
//
//  Created by Dinara on 24.03.2024.
//

import Foundation

final class ProfileService {
    static let shared = ProfileService()
    private var urlSession = URLSession.shared
    private var token: String?
    private var urlSessionTask: URLSessionTask?
    private let tokenKey = "6209b976-c7aa-4061-8574-573765a55e71"

    private init(
        token: String? = nil,
        urlSessionTask: URLSessionTask? = nil
    ) {
        self.token = token
        self.urlSessionTask = urlSessionTask
    }

    func fetchProfile() {
        self.fetchProfile { result in
            switch result {
            case .success(let profile):
                let response = Profile(
                    name: profile.name,
                    avatar: profile.avatar,
                    description: profile.description,
                    website: profile.website,
                    nfts: profile.nfts,
                    likes: profile.likes,
                    id: profile.id
                )
            case .failure(let error):
                fatalError("Error: \(error)")
            }
        }
    }

    func fetchProfile(completion: @escaping (Result<Profile, Error>) -> Void) {
        guard let request = makeFetchProfileRequest() else {
            assertionFailure("Invalid request")
            completion(.failure(NetworkError.invalidRequest))
            return
        }

        urlSessionTask = urlSession.objectTask(for: request) { (response: Result<Profile, Error>) in
            switch response {
            case .success(let profileResult):
                completion(.success(profileResult))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}

private extension ProfileService {
    func makeFetchProfileRequest() -> URLRequest? {
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host  = "d5dn3j2ouj72b0ejucbl.apigw.yandexcloud.net"
        urlComponents.path = "/api/v1/profile/1"

        guard let url = urlComponents.url else {
            fatalError("Failed to create URL")
        }

        var request = URLRequest(url: url)

        request.httpMethod = "GET"
        print(request)

        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue(tokenKey, forHTTPHeaderField: "X-Practicum-Mobile-Token")
        return request
    }
}
