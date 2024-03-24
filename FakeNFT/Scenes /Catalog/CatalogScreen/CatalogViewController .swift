//
//  CatalogViewController .swift
//  FakeNFT
//
//  Created by admin on 24.03.2024.
//

import UIKit
import Kingfisher
import ProgressHUD

protocol CatalogViewControllerProtocol: AnyObject {
    func reloadTableView()
}

final class CatalogViewController: UIViewController, CatalogViewControllerProtocol {
    
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
    
    private var presenter: CatalogPresenterProtocol
    
    private let tableViewTopSpacing: CGFloat = 20
    private let tableViewSideSpacing: CGFloat = 16
    private let tableViewHeight: CGFloat = 187
    
    init(presenter: CatalogPresenterProtocol) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        presenter.viewController = self
        loadNftToCatalog()
    }
    
    func reloadTableView() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
            self.refreshControl.endRefreshing()
            ProgressHUD.dismiss()
        }
    }
    
    //MARK: - @objc func
    
    @objc func showSortingMenu() {
        let alertMenu = UIAlertController(title: L10n.Catalog.sorting, message: nil, preferredStyle: .actionSheet)
        alertMenu.addAction(UIAlertAction(title: L10n.Catalog.sortByName, style: .default, handler: { [weak self] _ in
            self?.presenter.sortNFT(by: .name)
            self?.reloadTableView()
        }))
        alertMenu.addAction(UIAlertAction(title: L10n.Catalog.sortByNFTCount, style: .default, handler: { [weak self] _ in
            self?.presenter.sortNFT(by: .nftCount)
            self?.reloadTableView()
        }))
        alertMenu.addAction(UIAlertAction(title: L10n.Catalog.close, style: .cancel))
        
        present(alertMenu, animated: true)
    }
    
    @objc func loadNftToCatalog() {
        ProgressHUD.show()
        presenter.fetchCollections()
    }
    
}
//MARK: - UITableViewDataSource

extension CatalogViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        presenter.dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CatalogViewCell.catalogViewCellReuseIdentifier,
                                                       for: indexPath) as? CatalogViewCell else { return UITableViewCell() }
        let nftModel = presenter.dataSource[indexPath.row]
        let url = URL(string: nftModel.cover.encodeUrl)
        cell.cellImage.kf.setImage(with: url)
        cell.cellNameLabel.text = " \(nftModel.name) (\(nftModel.nftCount))"
        ProgressHUD.dismiss()
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        tableViewHeight
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
        tableView.refreshControl = refreshControl
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: tableViewSideSpacing),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -tableViewSideSpacing),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}
