//
//  StatisticsViewController.swift
//  FakeNFT
//
//  Created by Глеб Капустин on 05.04.2024.
//

import UIKit
import SnapKit

final class StatisticsViewController: UIViewController {
    
    enum Section {
        case main
    }
    
    private lazy var dataSource: UITableViewDiffableDataSource<Section, UserDetailed> = {
        UITableViewDiffableDataSource<Section, UserDetailed>(
            tableView: tableView,
            cellProvider: {[weak self] (tableView, indexPath, user) -> UITableViewCell? in
                
                guard let self else { return UITableViewCell()}
                let cell: StatisticsTableViewCell = tableView.dequeueReusableCell()
                cell.set(user: user)
                return cell
            })
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(StatisticsTableViewCell.self)
        tableView.showsVerticalScrollIndicator = false
        tableView.delegate = self
        tableView.rowHeight = 80
        tableView.separatorStyle = .none
        return tableView
    }()
    
    private let usersService = UserDetailedServiceImpl(networkClient: DefaultNetworkClient())
    private var users: [UserDetailed] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureVC()
    }
    
    private func configureVC() {
        navigationController?.navigationBar.tintColor = .label
        let sortButton = UIBarButtonItem(title: "",
                                         style: .plain,
                                         target: self,
                                         action: #selector(sortButtonPressed))
        sortButton.image = UIImage(resource: .sort)
        navigationItem.rightBarButtonItem = sortButton
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(20)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
            make.bottom.equalToSuperview()
        }
        
        usersService.loadUsers {[weak self] result in
            guard let self else { return }
            switch result {
            case .success(let users):
                self.users = users.sorted(by: { $0.rating < $1.rating })
                updateData(with: self.users)
                
            case .failure(let error):
                //TODO: - доделать обработку ошибок
                print(error)
            }
        }
    }
    
    @objc private func sortButtonPressed() {
        let alert = UIAlertController(
            title: nil,
            message: "Сортировка",
            preferredStyle: .actionSheet)
        
        let nameSortAction = UIAlertAction(title: "По имени", style: .default) { [weak self] _ in
            guard let self else { return }
            users = users.sorted(by: { $0.name < $1.name })
            updateData(with: users)
        }
        
        let ratingSortAction = UIAlertAction(title: "По рейтингу", style: .default){ [weak self] _ in
        guard let self else { return }
        users = users.sorted(by: { $0.rating < $1.rating })
        updateData(with: users)
    }
        
        let cancelAlertAction = UIAlertAction(title: "Закрыть", style: .cancel)
        
        alert.addAction(nameSortAction)
        alert.addAction(ratingSortAction)
        alert.addAction(cancelAlertAction)
        present(alert, animated: true)
    }
    
    func updateData(with users: [UserDetailed]) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, UserDetailed>()
        snapshot.appendSections([.main])
        snapshot.appendItems(users)
        dataSource.apply(snapshot, animatingDifferences: true)
    }
}

extension StatisticsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let assemblyBuilder = StatisticsAssemblyBuilderImpl(networkClient: DefaultNetworkClient())
        let statisticsInput = StatisticsInput.userDetailed(users[indexPath.row])
        let router = StatisticsRouterImpl(navigationController: self.navigationController, assemblyBuilder: assemblyBuilder)
        router.push(with: statisticsInput)
    }
}
