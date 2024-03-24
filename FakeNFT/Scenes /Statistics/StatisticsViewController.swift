//
//  StatisticsViewController.swift
//  FakeNFT
//
//  Created by Глеб Капустин on 24.03.2024.
//

import UIKit

final class StatisticsViewController: UIViewController {
    
    let cell = NFTCollectionViewCellThreePerRow(frame: .zero)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        
        cell.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(cell)
        cell.constraintCenters(to: view)
        NSLayoutConstraint.activate([
            cell.heightAnchor.constraint(equalToConstant: 172),
            cell.widthAnchor.constraint(equalToConstant: 108)
        ])
    }
}


