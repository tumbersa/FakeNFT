//
//  CartService.swift
//  FakeNFT
//
//  Created by Марат Хасанов on 02.04.2024.
//

import Foundation

typealias CartCompletion = (Result<Cart, Error>) -> Void
typealias NftOrderCompletion = (Result<Cart, Error>) -> Void

protocol CartService {
    func loadCart(httpMethod: HttpMethod, model: (any Encodable)?, completion: @escaping CartCompletion)
    func deleteFromCart(nftId: String, completion: @escaping CartCompletion)
    func updateOrder(nftsIds: [String], completion: @escaping (Error?) -> Void)
}

final class CartServiceImpl: CartService {
    
    private let networkClient: NetworkClient
    
    init(networkClient: NetworkClient) {
        self.networkClient = networkClient
    }
    
    func loadCart(httpMethod: HttpMethod, model: (any Encodable)?, completion: @escaping CartCompletion) {
        let model = httpMethod == .get ? nil : model
        let request = CartRequest(method: httpMethod, model: model)
        
        networkClient.send(request: request, type: Cart.self) { result in
            switch result {
            case .success(let cart):
                completion(.success(cart))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func deleteFromCart(nftId: String, completion: @escaping CartCompletion) {
        let request = CartRequest(method: .delete, model: nil)
        
        networkClient.send(request: request, type: Cart.self) { result in
            switch result {
            case .success(let cart):
                completion(.success(cart))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func updateOrder(nftsIds: [String], completion: @escaping (Error?) -> Void) {
        guard let url = URL(string: "\(RequestConstants.baseURL)/api/v1/orders/1") else {
            print("Invalid URL")
            return
        }
        // тело запроса
        let nftsString = nftsIds.joined(separator: ",")
        let bodyString = "nfts=\(nftsString)"
        guard let bodyData = bodyString.data(using: .utf8) else {
            print("Failed to encode body")
            return
        }
        
        // Создаем URLRequest
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.setValue("6209b976-c7aa-4061-8574-573765a55e71", forHTTPHeaderField: "X-Practicum-Mobile-Token")
        request.httpBody = bodyData
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
                completion(error) // Вызываем замыкание completion с передачей ошибки
                return
            }
            
            if let data = data, let responseString = String(data: data, encoding: .utf8) {
                print("Response: \(responseString)")
            }
            completion(nil) // Вызываем замыкание completion без ошибки, т.к. запрос выполнен успешно
        }
        task.resume()
    }
}
