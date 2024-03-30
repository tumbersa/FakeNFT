//
//  MyNFTViewController.swift
//  FakeNFT
//
//  Created by Dinara on 27.03.2024.
//

import SnapKit
import UIKit

// MARK: - MyNFT ViewController
final class MyNFTViewController: UIViewController {

    // MARK: - Private Properties
    private var myNFTs = [
        NFTCellModel(
            name: "Lilo",
            images: UIImage(named: "nft_icon") ?? UIImage(),
            rating: 3,
            price: 1.78,
            author: "John Doe",
            id: "1"
        )
    ]

    // private var myNFTs = [NFTCellModel]()
    // для проверки верстки экрана отсутствия Моих NFT

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
        tableView.backgroundColor = .systemBackground
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
        setupNavigation()
        setupViews()
        setupConstraints()
        updateEmptyView()
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

    @objc func filterButtonDidTap() {
        print("Filter button did tap")
    }

    func updateEmptyView() {
        if myNFTs.isEmpty {
            self.emptyLabel.isHidden = false
            tableView.isHidden = true
        } else {
            emptyLabel.isHidden = true
        }
    }
}

// MARK: - UITableViewDataSource
extension MyNFTViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myNFTs.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: MyNFTCell.cellID,
            for: indexPath
        ) as? MyNFTCell else {
            fatalError("Could not cast to MyNFTCell")
        }
        let nft = myNFTs[indexPath.row]
        cell.configureCell(with: nft)
        cell.selectionStyle = .none

        return cell
    }
}

// MARK: - UITableViewDelegate
extension MyNFTViewController: UITableViewDelegate {
}
