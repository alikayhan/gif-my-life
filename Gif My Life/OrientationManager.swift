//
//  OrientationManager.swift
//  Gif My Life
//
//  Created by Ali Kayhan on 05/08/2017.
//  Copyright © 2017 Ali Kayhan. All rights reserved.
//

import Foundation
import UIKit

struct OrientationManager {
    
    // MARK: - Methods
    
    // Lock orientation to a specific orientation
    static func lockOrientation(to orientation: UIInterfaceOrientationMask) {
        guard let delegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        delegate.allowedOrientations = orientation
    }
    
    // Lock orientation to a specific orientation and rotate to it
    static func lockOrientation(to orientation: UIInterfaceOrientationMask, andRotateTo rotationOrientation: UIInterfaceOrientation) {
        lockOrientation(to: orientation)
        UIDevice.current.setValue(rotationOrientation.rawValue, forKey: "orientation")
    }
}
