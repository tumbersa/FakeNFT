//
//  ProfileNFTService.swift
//  FakeNFT
//
//  Created by Dinara on 05.04.2024.
//

import Foundation

// MARK: - ProfileNFTService
final class ProfileNFTService {
    static let shared = ProfileNFTService()
    private(set) var NFTs: [NFT]?
    private var urlSession = URLSession.shared
    private var id: String?
    private var urlSessionTask: URLSessionTask?

    private init(
        NFTs: [NFT]? = nil,
        id: String? = nil,
        urlSessionTask: URLSessionTask? = nil
    ) {
        self.NFTs = NFTs
        self.id = id
        self.urlSessionTask = urlSessionTask
    }

    func fetchNFT(_ id: String) {
        self.fetchNFTs(id) { result in
            switch result {
            case .success(let myNFTs):
                self.NFTs = myNFTs
            case .failure(let error):
                fatalError("Error: \(error)")
            }
        }
    }

    func fetchNFTs(_ id: String, completion: @escaping (Result<[NFT], Error>) -> Void) {
        guard let request = makeFetchNFTRequest(id: id) else {
            assertionFailure("Invalid request")
            completion(.failure(NetworkError.invalidRequest))
            return
        }

        urlSessionTask = urlSession.objectTask(for: request) { [weak self] (response: Result<[NFT], Error>) in
            switch response {
            case .success(let NFTs):
                var myNFTs: [NFT] = []
                for nft in NFTs {
                    let newNFT = NFT(
                        createdAt: nft.createdAt,
                        name: nft.name,
                        images: nft.images,
                        rating: nft.rating,
                        description: nft.description,
                        price: nft.price,
                        author: nft.author,
                        id: nft.id
                    )
                    myNFTs.append(newNFT)
                }
                self?.NFTs = myNFTs
                completion(.success(myNFTs))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}

private extension ProfileNFTService {
    func makeFetchNFTRequest(id: String) -> URLRequest? {
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host  = "64858e8ba795d24810b71189.mockapi.io"
        urlComponents.path = "/api/v1/nft\(id)"

        guard let url = urlComponents.url else {
            fatalError("Failed to create URL")
        }

        var request = URLRequest(url: url)

        request.httpMethod = "GET"

        request.setValue("Accept: application/json", forHTTPHeaderField: "Content-Type")

        return request
    }
}
