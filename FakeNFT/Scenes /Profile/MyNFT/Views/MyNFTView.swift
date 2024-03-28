//
//  MyNFTView.swift
//  FakeNFT
//
//  Created by Dinara on 27.03.2024.
//

import SnapKit
import UIKit

// MARK: - MyNFT View
final class MyNFTView: UIView {

    // MARK: - Private Properties
    private var myNFTs = [
        NFTCellModel(
            image: UIImage(named: "nft_icon") ?? UIImage(),
            name: "Lilo",
            rating: UIImage(named: "star_icon") ?? UIImage(),
            author: "от John Doe",
            price: "1,78 ETH",
            id: "1"
        )
    ]

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
        return tableView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension MyNFTView {
    func setupViews() {
        self.backgroundColor = .systemBackground
        self.addSubview(tableView)
    }

    func setupConstraints() {
        tableView.snp.makeConstraints { make in
            make.top.bottom.equalTo(self.safeAreaLayoutGuide)
            make.leading.trailing.equalToSuperview()
        }
    }
}

extension MyNFTView: UITableViewDataSource {
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

        return cell
    }
}

extension MyNFTView: UITableViewDelegate {

}
