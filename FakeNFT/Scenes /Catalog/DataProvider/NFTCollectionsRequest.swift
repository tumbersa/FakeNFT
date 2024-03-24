//
//  NFTCollectionsRequest.swift
//  FakeNFT
//
//  Created by admin on 24.03.2024.
//

import Foundation

struct NFTCollectionsRequest: NetworkRequest {
    var endpoint: URL?
    
    init() {
        guard let endpoint = URL(string: "https://64858e8ba795d24810b71189.mockapi.io/api/v1/collections") else { return }
        self.endpoint = endpoint
    }
}
