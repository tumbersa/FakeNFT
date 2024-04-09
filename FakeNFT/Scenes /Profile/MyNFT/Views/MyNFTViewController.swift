//
//  MyNFTViewController.swift
//  FakeNFT
//
//  Created by Dinara on 27.03.2024.
//

import SnapKit
import UIKit

protocol MyNFTViewControllerProtocol: AnyObject {
    var presenter: MyNFTPresenter? { get set }
    func updateMyNFTs(_ nfts: NFT?)
}

// MARK: - MyNFT ViewController
final class MyNFTViewController: UIViewController {

    // MARK: - Private Properties
    var presenter: MyNFTPresenter?
    private var myNFTs: [NFT] = []
    private var nftID: [String]
    private var likedNFT: [String]

    init(nftID: [String], likedID: [String]) {
        self.nftID = nftID
        self.likedNFT = likedID
        super.init(nibName: nil, bundle: nil)
        print("Инициализация MyNFTViewController с nftID: \(nftID), likedID: \(likedID)")
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    deinit {
        print("Деинициализация MyNFTViewController")
    }

    // MARK: - UI
    private lazy var navBackButton: UIBarButtonItem = {
        let button = UIBarButtonItem(
            image: UIImage(systemName: "chevron.backward"),
            style: .plain,
            target: self,
            action: #selector(navBackButtonDidTap))
        button.tintColor = UIColor(named: "ypBlack")
        return button
    }()

    private lazy var filterButton: UIBarButtonItem = {
        let button = UIBarButtonItem(
            image: UIImage(named: "filter_button_icon"),
            style: .plain,
            target: self,
            action: #selector(filterButtonDidTap)
        )
        button.tintColor = UIColor(named: "ypBlack")
        return button
    }()

    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(
            MyNFTCell.self,
            forCellReuseIdentifier: MyNFTCell.cellID
        )
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .none
        tableView.allowsMultipleSelection = false
        tableView.isUserInteractionEnabled = true
        tableView.backgroundColor = .systemBackground
        return tableView
    }()

    private lazy var emptyLabel: UILabel = {
        let label = UILabel()
        label.text = L10n.Profile.emptyNFTLabel
        label.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        label.textColor = UIColor(named: "ypBlack")
        return label
    }()

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        print("viewDidLoad вызван")

        setupNavigation()
        setupViews()
        setupConstraints()

        presenter = MyNFTPresenter(nftID: self.nftID, likedNFT: self.likedNFT)
        print("MyNFTPresenter создан")
        presenter?.view = self
        print("Привязка presenter к MyNFTViewController")
        presenter?.viewDidLoad()

        print("viewDidLoad завершен")
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let sortType = UserDefaults.standard.data(forKey: "sortType") {
            let type = try? PropertyListDecoder().decode(Filter.self, from: sortType)
            self.myNFTs = applySortType(by: type ?? .rating)
            tableView.reloadSections(IndexSet(integer: 0), with: .automatic)
        }
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        print("TableView frame: \(tableView.frame)")
    }
}

// MARK: - Private Extension
private extension MyNFTViewController {

    // MARK: - Setup Navigation
    func setupNavigation() {
        navigationItem.title = L10n.Profile.myNFT
        navigationItem.leftBarButtonItem = navBackButton
        navigationItem.rightBarButtonItem = filterButton
    }

    // MARK: - Setup Views
    func setupViews() {
        [tableView,
         emptyLabel
        ].forEach {
            view.addSubview($0)
        }
    }

    // MARK: - Setup Constraints
    func setupConstraints() {
        tableView.snp.makeConstraints { make in
            make.top.bottom.equalTo(view.safeAreaLayoutGuide)
            make.leading.trailing.equalToSuperview()
        }

        emptyLabel.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
        }
    }

    // MARK: - Actions
    @objc func navBackButtonDidTap() {
        self.navigationController?.popViewController(animated: true)
    }

    func saveSortType(type: Filter) {
        let type = try? PropertyListEncoder().encode(type)
        UserDefaults.standard.set(type, forKey: "sortType")
    }

    func applySortType(by type: Filter) -> [NFT] {
        let nfts = myNFTs

        switch type {
        case .name:
            return nfts.sorted(by: { $0.name < $1.name })
        case .rating:
            return nfts.sorted(by: { $0.rating > $1.rating })
        case .price:
            return nfts.sorted(by: { $0.price > $1.price })
        }
    }

    @objc func filterButtonDidTap() {
        print("Filter button did tap")

        let alert = UIAlertController(
            title: nil,
            message: L10n.Profile.filter,
            preferredStyle: .actionSheet
        )

        let byPriceAction = UIAlertAction(
            title: L10n.Profile.byPrice,
            style: .default
        ) { [weak self] _ in
            self?.myNFTs = self?.applySortType(by: .price) ?? []
            self?.saveSortType(type: .price)
            self?.tableView.reloadSections(IndexSet(integer: 0), with: .automatic)
        }

        let byRatingAction = UIAlertAction(
            title: L10n.Profile.byRaiting,
            style: .default
        ) { [weak self] _ in
            self?.myNFTs = self?.applySortType(by: .rating) ?? []
            self?.saveSortType(type: .rating)
            self?.tableView.reloadSections(IndexSet(integer: 0), with: .automatic)
        }

        let byNameAction = UIAlertAction(
            title: L10n.Profile.byName,
            style: .default
        ) { [weak self] _ in
            self?.myNFTs = self?.applySortType(by: .name) ?? []
            self?.saveSortType(type: .name)
            self?.tableView.reloadSections(IndexSet(integer: 0), with: .automatic)
        }

        let close = UIAlertAction(
            title: L10n.Profile.close,
            style: .cancel
        )

        alert.addAction(byPriceAction)
        alert.addAction(byRatingAction)
        alert.addAction(byNameAction)
        alert.addAction(close)

        present(alert, animated: true)
    }
}

// MARK: - UITableViewDataSource
extension MyNFTViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("Count of nfts in presenter: \(presenter?.nfts.count ?? 0)")
        return presenter?.nfts.count ?? 0

    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: MyNFTCell.cellID,
            for: indexPath
        ) as? MyNFTCell else {
            fatalError("Could not cast to MyNFTCell")
        }

        guard let nft = presenter?.nfts[indexPath.row] else {
            return UITableViewCell()
        }
        print("Count of nfts in presenter: \(presenter?.nfts.count ?? 0)")

        cell.configureCell(with: nft)
        cell.selectionStyle = .none

        return cell
    }
}

// MARK: - UITableViewDelegate
extension MyNFTViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140
    }
}

extension MyNFTViewController: MyNFTViewControllerProtocol {
    func updateMyNFTs(_ nfts: NFT?) {
        guard let presenter = presenter else {
            print("Presenter is nil")
            return
        }

        guard let nfts = nfts else { return }
        print("NFT получены: \(nfts)")

        print("Перед добавлением NFT: \(myNFTs.count)")

        self.myNFTs.append(nfts)

        print("NFT добавлены в presenter.nfts: \(nfts)")
        DispatchQueue.main.async {
            if  self.myNFTs.isEmpty {
                self.emptyLabel.isHidden = false
                self.tableView.isHidden = true
                self.navigationItem.title = ""
                self.filterButton.image = nil
            } else {
                self.emptyLabel.isHidden = true
                self.tableView.isHidden = false
            }
            self.tableView.reloadData()
        }
    }
}
