//
//  RatingStackView.swift
//  FakeNFT
//
//  Created by Глеб Капустин on 24.03.2024.
//

import UIKit

final class RatingStackView: UIStackView {
    
    private lazy var arrOfStars: [UIImageView] = {
        (0...4).map{ _ in
            UIImageView(image: UIImage(systemName: "star.fill") )
        }
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configure()
        set(rating: 1)
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func set(rating: Int) {
        for i in 0..<arrOfStars.count {
            if i < rating {
                arrOfStars[i].tintColor = .yellow
            } else {
                arrOfStars[i].tintColor = .segmentInactive
            }
        }
    }
    
    private func configure() {
        arrOfStars.forEach { addArrangedSubview($0) }
        spacing = 2
        axis = .horizontal
        distribution = .fillEqually
    }
}

@available(iOS 17.0, *)
#Preview {
    RatingStackView(frame: .zero)
}
