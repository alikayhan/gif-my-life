//
//  ActivityIndicator.swift
//  Gif My Life
//
//  Created by Ali Kayhan on 28/06/2017.
//  Copyright © 2017 Ali Kayhan. All rights reserved.
//

import Foundation
import UIKit
import NVActivityIndicatorView

struct ActivityIndicator {
    
    // MARK: - Properties
    let indicator: NVActivityIndicatorView!
    
    // MARK: - Initializers
    
    // Construct a Gif object from a dictionary
    init(on view: UIView) {
        indicator = NVActivityIndicatorView(frame: CGRect(x:0, y:0, width:60, height:60), type: .ballGridPulse, color: UIConstants.Color.GMLPurple)
        indicator.center = view.center
        view.addSubview(indicator)
    }
}
