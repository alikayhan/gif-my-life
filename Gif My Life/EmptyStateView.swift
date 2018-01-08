//
//  EmptyStateView.swift
//  Gif My Life
//
//  Created by Ali Kayhan on 20/07/2017.
//  Copyright © 2017 Ali Kayhan. All rights reserved.
//

import Foundation
import UIKit

class EmptyStateView: UIStackView {
    
    // MARK: - Properties
    var iconView = UIImageView()
    var textLabel = UILabel()
    
    // MARK: - Initializers
    init(frame: CGRect, icon: UIImage, text: String) {
        super.init(frame: frame)
        
        let imageView = UIImageView()
        imageView.heightAnchor.constraint(equalToConstant: 120.0).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: 120.0).isActive = true
        imageView.image = icon
        imageView.tintColor = UIConstants.Color.GMLPink
        imageView.contentMode = .scaleAspectFit
        self.iconView = imageView
        
        let textLabel = UILabel()
        textLabel.widthAnchor.constraint(equalToConstant: frame.width - 60.0).isActive = true
        textLabel.text  = text
        textLabel.textAlignment = .center
        textLabel.numberOfLines = 0
        textLabel.lineBreakMode = .byWordWrapping
        textLabel.textColor = .black
        self.textLabel = textLabel
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Methods
    func place(on view: UIView) {
        self.axis = .vertical
        self.distribution = .equalSpacing
        self.alignment = .center
        self.spacing = 16.0
        
        self.addArrangedSubview(iconView)
        self.addArrangedSubview(textLabel)
        self.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(self)
        
        // Constraints for empty state view
        self.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        self.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
    
}
