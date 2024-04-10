//
//  PayNftPresenter.swift
//  FakeNFT
//
//  Created by Марат Хасанов on 09.04.2024.
//

import Foundation
import SafariServices

final class PayNftPresenter {
    private weak var view: PayNftView?
    
    func showSafariView() -> SFSafariViewController {
        let urlString = "https://yandex.ru/legal/practicum_termsofuse/"
        guard let url = URL(string: urlString) else { fatalError("Invalid URL") }
        let vc = SFSafariViewController(url: url)
        return vc
    }
}
