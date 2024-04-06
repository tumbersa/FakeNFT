//
//  GetNFTById.swift
//  FakeNFT
//
//  Created by admin on 06.04.2024.
//

import Foundation

struct GetNFTById: NetworkRequest {
    var endpoint: URL?

    init(id: String) {
        guard let endpoint = URL(string: "\(NetworkConstants.baseURL)/api/v1/nft/\(id)") else { return }
           self.endpoint = endpoint
       }
}
