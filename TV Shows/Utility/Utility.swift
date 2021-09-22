//
//  Utility.swift
//  TV Shows
//
//  Created by Kiran R on 22/09/21.
//

import UIKit

public struct Utility {
    
    public func getStackView(axis: NSLayoutConstraint.Axis,
                             alignment: UIStackView.Alignment,
                             distribution: UIStackView.Distribution,
                             spacing: CGFloat) -> UIStackView {
        
        let stackView = UIStackView(frame: .zero)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = axis
        stackView.alignment = alignment
        stackView.distribution = distribution
        stackView.spacing = spacing
        
        return stackView
        
    }
    
    public func getTextField(height: Int, placeHolderImage: UIImage, placeHolderName: String) -> UITextField {
        
        let textField = UITextField(frame: .zero)
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.heightAnchor.constraint(equalToConstant: CGFloat(height)).isActive = true
        textField.placeholder = placeHolderName
        textField.leftViewMode = .always
        textField.leftView = UIImageView(image: placeHolderImage)
        return textField
        
    }
    
    public func getLabel(_ font: UIFont,
                         color: UIColor,
                         numberOfLines: Int = 0) -> UILabel {
        
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = numberOfLines
        label.font = font
        label.textColor = color
        return label
        
        
    }
    
    public func getView(color: UIColor, width: Int, height: Int) -> UIView{
        
        let line = UIView(frame: .zero)
        line.translatesAutoresizingMaskIntoConstraints = false
        line.backgroundColor = color
        line.widthAnchor.constraint(equalToConstant: CGFloat(width)).isActive = true
        line.heightAnchor.constraint(equalToConstant: CGFloat(height)).isActive = true
        
        return line
        
    }
    
    public func getRoundedView(_ size: CGFloat, radius: CGFloat) -> UIView {
        
        let roundedView = UIView(frame: .zero)
        roundedView.translatesAutoresizingMaskIntoConstraints = false
        roundedView.layer.cornerRadius = radius
        roundedView.backgroundColor = .lightGray
        
        NSLayoutConstraint.activate([
        
            roundedView.heightAnchor.constraint(equalToConstant: size),
            roundedView.widthAnchor.constraint(equalToConstant: size)
        
        ])
        
        return roundedView
        
    }
    
    
}
public enum NetworkErrors: Error {
    
    case wrongUrl
    case unKnownResponse
    case parseError
    
}

extension UIImage {
    
    func resizeImage(targetSize: CGSize) -> UIImage {
        let size = self.size
        
        let widthRatio  = targetSize.width  / size.width
        let heightRatio = targetSize.height / size.height
        
        var newSize: CGSize
        if(widthRatio > heightRatio) {
            newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
        } else {
            newSize = CGSize(width: size.width * widthRatio,  height: size.height * widthRatio)
        }
        
        let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
        
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        self.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
    
}

