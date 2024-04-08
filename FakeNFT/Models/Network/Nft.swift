import UIKit

struct Nft: Decodable {
    let createdAt: String
    let name: String
    let images: [URL]
    let rating: Int
    let description: String
    let price: Double
    let author: String
    let id: String
}

struct NftLoaded {
    let createdAt: String
    let name: String
    let image: UIImage
    let rating: Int
    let description: String
    let price: Double
    let author: String
    let id: String
}
