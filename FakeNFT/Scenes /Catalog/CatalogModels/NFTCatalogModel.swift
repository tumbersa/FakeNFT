//
//  NFTCatalogModel.swift
//  FakeNFT
//
//  Created by admin on 24.03.2024.
//

import Foundation

struct NFTCatalogModel: Codable {
    let createdAt: Date
        let name: String
        let cover: String
        let nfts: [Int]
        let description: String
        let author: Int
        let id: String
}
