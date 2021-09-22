//
//  showsCollectionViewCell.swift
//  TV Shows
//
//  Created by Harikrishnan S R on 22/09/21.
//

import UIKit

class ShowsCollectionViewCell: UICollectionViewCell {
 
    private let utility = Utility()
    
    deinit {
        print("ShowsCollectionViewCell deinited")
    }
    
    func setView(image: UIImage, labelValue: String) {
        
        self.subviews.forEach { item in
            item.removeFromSuperview()
        }
        
        let mainStackView = utility.getStackView(axis: .vertical, alignment: .fill, distribution: .fill, spacing: 2)
      
        let imageView = UIImageView(image: image)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        let label = utility.getLabel( UIFont.systemFont(ofSize: 18, weight: .regular), color: .white)
        label.text = labelValue
        label.numberOfLines = 1
        label.backgroundColor = .black
        label.textAlignment = .center
        label.heightAnchor.constraint(equalToConstant: 30).isActive = true
        mainStackView.addArrangedSubview(imageView)
        mainStackView.addArrangedSubview(label)
        
        setConstrain(mainStackView)
    }
    
}

//MARK:- Private methods
extension ShowsCollectionViewCell {
    
    private func setConstrain(_ stackViewiew: UIStackView) {
        
        self.addSubview(stackViewiew)
        
        NSLayoutConstraint.activate([
        
            stackViewiew.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            stackViewiew.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            stackViewiew.topAnchor.constraint(equalTo: self.topAnchor),
            stackViewiew.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        
        ])
        
    }
    
}
