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
        let encodedName = name
        let encodedAvatar = avatar.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) ?? ""
        let encodedDescription = description
        let encodedWebsite = website.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) ?? ""
        let encodedNfts = nfts.map { String($0) }.joined(separator: ",")
        let encodedLikes = likes.map { String($0) }.joined(separator: ",")
        let encodedId = id
        
        return "&name=\(encodedName)&avatar=\(encodedAvatar)&description=\(encodedDescription)&website=\(encodedWebsite)&nfts=\(encodedNfts),&likes=\(encodedLikes),&id=\(encodedId)"
    }
}
