//
//  Cart.swift
//  FakeNFT
//
//  Created by Глеб Капустин on 25.03.2024.
//

import Foundation

struct Cart: Codable {
    let nfts: [String]
    let id: String
    
    func toFormData() -> String {
        let encodedNfts = nfts.map { $0.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "" }.joined(separator: ",")
        let encodedId = id.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        
        return "&nfts=\(encodedNfts)&id=\(encodedId)"
    }
}
