//
//  ProfileGetRequest.swift
//  FakeNFT
//
//  Created by admin on 06.04.2024.
//

import Foundation

struct ProfileGetRequest: NetworkRequest {
    var endpoint: URL?
    init() {
        guard let endpoint = URL(string: "\(NetworkConstants.baseURL)/api/v1/profile/1") else { return }
        self.endpoint = endpoint
    }
}
