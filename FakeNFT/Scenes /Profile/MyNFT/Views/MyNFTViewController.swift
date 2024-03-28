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

    private lazy var myNFTView: MyNFTView = {
        let view = MyNFTView()
        return view
    }()

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigation()
        setupViews()
        setupConstraints()
    }
}

private extension MyNFTViewController {
    func setupNavigation() {
        navigationItem.title = L10n.Profile.myNFT
        navigationItem.leftBarButtonItem = navBackButton
        navigationItem.rightBarButtonItem = filterButton
    }

    func setupViews() {
        view.addSubview(myNFTView)
    }

    func setupConstraints() {
        myNFTView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    // MARK: - Actions
    @objc private func navBackButtonDidTap() {
        self.navigationController?.popViewController(animated: true)
    }

    @objc private func filterButtonDidTap() {
        print("Filter button did tap")
    }
}
