//
//  Cart.swift
//  FakeNFT
//
<<<<<<< HEAD
//  Created by Глеб Капустин on 25.03.2024.
=======
//  Created by Марат Хасанов on 03.04.2024.
>>>>>>> Epic/Cart
//

import Foundation

struct Cart: Codable {
<<<<<<< HEAD
    let nfts: [String]
    let id: String
    
    func toFormData() -> String {
        let encodedNfts = nfts.map { String($0) }.joined(separator: ",")
        let encodedId = id
        
        return "&nfts=\(encodedNfts),&id=\(encodedId)"
    }
=======
    let id: String
    let nfts: [String]
>>>>>>> Epic/Cart
}
