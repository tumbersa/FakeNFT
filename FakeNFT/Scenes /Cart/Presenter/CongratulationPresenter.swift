//
//  CongratulationPresenter.swift
//  FakeNFT
//
//  Created by Марат Хасанов on 15.04.2024.
//

import Foundation

final class CongratulationPresenter {
    
    private weak var view: CongratulationView?
    
    private var cartService: CartService = CartServiceImpl(networkClient: DefaultNetworkClient())
    
    func getPaymentOrder() {
        let newId: [String] = []
        self.cartService.updateOrder(nftsIds: newId, update: false) { [weak self] error in
            guard let self = self else { return }
            if let error = error {
                return
            }
        }
    }
}
