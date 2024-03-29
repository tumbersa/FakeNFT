//
//  Profile.swift
//  FakeNFT
//
//  Created by Глеб Капустин on 25.03.2024.
//

import Foundation

struct Profile: Codable {
    let name: String
    let avatar: String
    let description: String
    let website: String
    let nfts, likes: [String]
    let id: String
    
    func toFormData() -> String {
        let encodedName = name.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        let encodedAvatar = avatar.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        let encodedDescription = description.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        let encodedWebsite = website.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        let encodedNfts = nfts.map { $0.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "" }.joined(separator: ",")
        let encodedLikes = likes.map { $0.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "" }.joined(separator: ",")
        let encodedId = id.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        
        return "&name=\(encodedName)&avatar=\(encodedAvatar)&description=\(encodedDescription)&website=\(encodedWebsite)&nfts=\(encodedNfts)&likes=\(encodedLikes)&id=\(encodedId)"
    }
}
