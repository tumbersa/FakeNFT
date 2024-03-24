//
//  CatalogPresenter.swift
//  FakeNFT
//
//  Created by admin on 24.03.2024.
//

import UIKit

protocol CatalogPresenterProtocol: AnyObject {
    var dataSource: [NFTCatalogModel] { get }
    var viewController: CatalogViewControllerProtocol? { get set }
    func fetchCollections()
    func sortNFT(by parameters: NFTCatalogSortingParameters)
}

final class CatalogPresenter: CatalogPresenterProtocol {
    
    weak var viewController: CatalogViewControllerProtocol?
    private var dataProvider: DataProviderProtocol
    
    var dataSource: [NFTCatalogModel] {
        dataProvider.NFTCollections
    }
    
    init(dataProvider: DataProviderProtocol) {
        self.dataProvider = dataProvider
    }
    
    func fetchCollections() {
        dataProvider.fetchNFTCollection { [weak self] in
            self?.viewController?.reloadTableView()
        }
    }
    
    func sortNFT(by parameters: NFTCatalogSortingParameters) {
        dataProvider.sortNFTCollections(by: parameters)
    }
}

