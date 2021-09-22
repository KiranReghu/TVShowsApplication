//
//  showsCollectionViewCell.swift
//  TV Shows
//
//  Created by Harikrishnan S R on 22/09/21.
//

import UIKit

class ShowsCollectionViewCell: UICollectionViewCell {
 
    private let utility = Utility()
    
    var imageView: UIImageView!
    
    var showName: UILabel!
    
    var labelRating: UILabel!
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        setView()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        print("ShowsCollectionViewCell deinited")
    }
    
}


extension ShowsCollectionViewCell {
    
    func setView() {
        
        let mainStackView = utility.getStackView(axis: .vertical, alignment: .fill, distribution: .fill, spacing: 2)
      
        imageView = UIImageView(image: UIImage(named: "dummy")!)
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        showName = utility.getLabel( UIFont.systemFont(ofSize: 18, weight: .regular), color: .white)
    
        showName.numberOfLines = 1
        showName.backgroundColor = .black
        showName.textAlignment = .center
        showName.heightAnchor.constraint(equalToConstant: 30).isActive = true
        mainStackView.addArrangedSubview(imageView)
        mainStackView.addArrangedSubview(showName)
        
        setConstrain(mainStackView)
        
        let ratingStarView = UIImageView(image: (UIImage(named: "GoldenStar")!).resizeImage(targetSize: CGSize(width: 40, height: 40)))
        ratingStarView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(ratingStarView)
        
        labelRating = utility.getLabel( UIFont.systemFont(ofSize: 14, weight: .regular), color: .black)
        
        labelRating.textAlignment = .center
        contentView.addSubview(labelRating)
        contentView.bringSubviewToFront(ratingStarView)
        contentView.bringSubviewToFront(labelRating)
              
        NSLayoutConstraint.activate([
            
            ratingStarView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -5),
            
            ratingStarView.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 5),
            labelRating.centerXAnchor.constraint(equalTo: ratingStarView.centerXAnchor),
            labelRating.centerYAnchor.constraint(equalTo: ratingStarView.centerYAnchor)
            
        ])
        
    }
    
    private func setConstrain(_ stackViewiew: UIStackView) {
        
        contentView.addSubview(stackViewiew)
        
        NSLayoutConstraint.activate([
        
            stackViewiew.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            stackViewiew.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            stackViewiew.topAnchor.constraint(equalTo: contentView.topAnchor),
            stackViewiew.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        
        ])
        
    }
    
}
