//
//  PortraitUIViewController.swift
//  Gif My Life
//
//  Created by Ali Kayhan on 05/08/2017.
//  Copyright © 2017 Ali Kayhan. All rights reserved.
//

import UIKit

class PortraitUIViewController: UIViewController {
    
    // MARK: - Lifecycle Functions
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        OrientationManager.lockOrientation(to: .portrait, andRotateTo: .portrait)
        
        // Check the network reachability
        if !(NetworkManager().shared.hasConnectivity()) {
            showAlert(with: UIConstants.Error.NoInternetConnection)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        OrientationManager.lockOrientation(to: .allButUpsideDown)
    }
    
    // MARK: - Show Alert
    func showAlert(with title: String, message: String? = nil) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: UIConstants.Title.AlertAction.OK, style: .default, handler: nil)
        alertController.addAction(okAction)
        
        present(alertController, animated: true, completion: nil)
    }
}
