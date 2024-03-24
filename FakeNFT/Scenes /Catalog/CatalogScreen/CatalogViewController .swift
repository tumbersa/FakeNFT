//
//  CatalogViewController .swift
//  FakeNFT
//
//  Created by admin on 24.03.2024.
//

import UIKit

final class CatalogViewController: UIViewController {
    
    private lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self,
                                 action: #selector(loadNftToCatalog),
                                 for: .valueChanged)
        return refreshControl
    }()
    
    private lazy var sortButton: UIBarButtonItem = {
        let button = UIBarButtonItem(image: Asset.CatalogImages.filterIcon.image,
                                     style: .plain,
                                     target: self,
                                     action: #selector(showSortingMenu))
        return button
    }()
    
    private lazy var tableView: UITableView = {
        var tableView = UITableView()
        tableView.register(CatalogViewCell.self, forCellReuseIdentifier: CatalogViewCell.catalogViewCellReuseIdentifier)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = Asset.Colors.ypWhite.color
        tableView.showsVerticalScrollIndicator = false
        tableView.separatorStyle = .none
        tableView.dataSource = self
        tableView.delegate = self
        return tableView
    }()
    
    private let tableViewTopSpacing: CGFloat = 20
    private let tableViewSideSpacing: CGFloat = 16
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    //MARK: - @objc func
    
    @objc func showSortingMenu() {
        let alertMenu = UIAlertController(title: L10n.Catalog.sorting, message: nil, preferredStyle: .actionSheet)
        alertMenu.addAction(UIAlertAction(title: L10n.Catalog.sortByName, style: .default, handler: { [weak self] _ in }))
        alertMenu.addAction(UIAlertAction(title: L10n.Catalog.sortByNFTCount, style: .default, handler: { [weak self] _ in }))
        alertMenu.addAction(UIAlertAction(title: L10n.Catalog.close, style: .cancel))
        
        present(alertMenu, animated: true)
    }
    
    @objc func loadNftToCatalog() {
        
    }
    
}
//MARK: - UITableViewDataSource

extension CatalogViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CatalogViewCell.catalogViewCellReuseIdentifier,
                                                       for: indexPath) as? CatalogViewCell else { return UITableViewCell() }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        180
    }
}
//MARK: - UITableViewDelegate

extension CatalogViewController: UITableViewDelegate {
    
}

//MARK: - ConfigUI

private extension CatalogViewController {
    
    func setupUI() {
        configNavBar()
        configUI()
    }
    
    func configNavBar() {
        sortButton.tintColor = Asset.Colors.ypBlack.color
        navigationController?.navigationBar.tintColor = Asset.Colors.ypWhite.color
        navigationItem.rightBarButtonItem = sortButton
    }
    
    func configUI() {
        view.backgroundColor = Asset.Colors.ypWhite.color
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: tableViewTopSpacing),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: tableViewSideSpacing),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -tableViewSideSpacing),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}
