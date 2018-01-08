//
//  SwipeViewController.swift
//  Gif My Life
//
//  Created by Ali Kayhan on 04/06/2017.
//  Copyright © 2017 Ali Kayhan. All rights reserved.
//

import UIKit

class SwipeViewController: EZSwipeController {
    
    // MARK: - Properties
    var viewControllerStack : [UIViewController]!
    var titles : [String]!
    
    // MARK: - Lifecycle Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIConstants.Color.GMLPink
    }
    
    // MARK: - Setup View
    override func setupView() {
        datasource = self
        navigationBarShouldNotExist = true
    }
}

// MARK: - SwipeViewController (EZSwipeControllerDataSource)

extension SwipeViewController: EZSwipeControllerDataSource {
    
    func viewControllerData() -> [UIViewController] {
        return viewControllerStack
    }
}
