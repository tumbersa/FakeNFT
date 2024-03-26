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
        guard let endpoint = URL(string: "https://d5dn3j2ouj72b0ejucbl.apigw.yandexcloud.net/api/v1/collections") else { return }
        self.endpoint = endpoint
    }
}
