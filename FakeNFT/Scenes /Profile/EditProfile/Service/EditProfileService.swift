//
//  EditProfileService.swift
//  FakeNFT
//
//  Created by Dinara on 11.04.2024.
//

import Foundation

// MARK: - EditProfileService
final class EditProfileService {
    static let shared = EditProfileService()
    private var urlSession = URLSession.shared
    private var urlSessionTask: URLSessionTask?

    private init(urlSessionTask: URLSessionTask? = nil) {
        self.urlSessionTask = urlSessionTask
    }

    func putProfileDetails(name: String, avatar: String, description: String, website: String, likes: [String]) {
        let profile = EditProfileModel(
            name: name,
            avatar: avatar,
            description: description,
            website: website,
            likes: likes
        )

//        updateProfileDetails(editProfileModel: profile) { [weak self] result in
//            switch result {
//            case .success(let profile):
//                self?.view.updateNewProfileDetails(profile)
//            case .failure(let error):
//                print("Failed to update profile details: \(error)")
//            }
//        }
    }

    func updateProfileDetails(editProfileModel: EditProfileModel,completion: @escaping (Result<Profile, Error>) -> Void) {
        
        guard let request = makePutRequest() else {
            assertionFailure("Invalid request")
            completion(.failure(NetworkError.invalidRequest))
            return
        }

        urlSessionTask = urlSession.objectTask(for: request) { (response: Result<Profile, Error>) in
            switch response {
            case .success(let profile):
                completion(.success(profile))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}

private extension EditProfileService {
    func makePutRequest() -> URLRequest? {
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host  = "d5dn3j2ouj72b0ejucbl.apigw.yandexcloud.net"
        urlComponents.path = "/api/v1/profile/1"

        guard let url = urlComponents.url else {
            fatalError("Failed to create URL")
        }

        var request = URLRequest(url: url)
        request.httpMethod = "PUT"

        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("6209b976-c7aa-4061-8574-573765a55e71", forHTTPHeaderField: "X-Practicum-Mobile-Token")

        return request
    }
}
