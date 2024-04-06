//
//  NftStatistics.swift
//  FakeNFT
//
//  Created by admin on 28.03.2024.
//

import UIKit

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

//struct MockNftStatistics: Hashable {
//    let name: String
//    let images: [UIImage]
//    let rating: Int
//    let price: Double
//    let id: String
//    
//    func hash(into hasher: inout Hasher) {
//        hasher.combine(id)
//    }
//}
