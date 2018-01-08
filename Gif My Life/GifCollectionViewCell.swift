//
//  GifCollectionViewCell.swift
//  Gif My Life
//
//  Created by Ali Kayhan on 05/07/2017.
//  Copyright © 2017 Ali Kayhan. All rights reserved.
//

import UIKit

class GifCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Properties
    var imageView = UIImageView()
    var activityIndicator = UIActivityIndicatorView()
    var downloadedGif: DownloadedGif!
    
    // MARK: - Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.activityIndicatorViewStyle = .whiteLarge
        activityIndicator.hidesWhenStopped = true
        
        contentView.addSubview(imageView)
        contentView.addSubview(activityIndicator)
        
        // Constraints for center, width and height of imageView
        let horizontalConstraint = NSLayoutConstraint(item: imageView, attribute: .centerX, relatedBy: .equal, toItem: contentView, attribute: .centerX, multiplier: 1, constant: 0)
        let verticalConstraint = NSLayoutConstraint(item: imageView, attribute: .centerY, relatedBy: .equal, toItem: contentView, attribute: .centerY, multiplier: 1, constant: 0)
        let widthConstraint = NSLayoutConstraint(item: imageView, attribute: .width, relatedBy: .equal, toItem: contentView, attribute: .width, multiplier: 1, constant: 0)
        let heightConstraint = NSLayoutConstraint(item: imageView, attribute: .height, relatedBy: .equal, toItem: contentView, attribute: .height, multiplier: 1, constant: 0)
        
        // Constraints for center of activityIndicator
        let activityIndicatorCenterXConstraint = NSLayoutConstraint(item: activityIndicator, attribute: .centerX, relatedBy: .equal, toItem: contentView, attribute: .centerX, multiplier: 1, constant: 0)
        let activityIndicatorCenterYConstraint = NSLayoutConstraint(item: activityIndicator, attribute: .centerY, relatedBy: .equal, toItem: contentView, attribute: .centerY, multiplier: 1, constant: 0)
        
        // Add constraints to resize and reposition imageView and activityIndicator
        // when device rotates
        contentView.addConstraints([horizontalConstraint, verticalConstraint, widthConstraint,heightConstraint, activityIndicatorCenterXConstraint, activityIndicatorCenterYConstraint])
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
