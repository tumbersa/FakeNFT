//
//  NftStatistics.swift
//  FakeNFT
//
//  Created by admin on 28.03.2024.
//

import Foundation

struct NftStatistics: Hashable {
    let name: String
    let images: [URL]
    let rating: Int
    let price: Double
    let id: String
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
