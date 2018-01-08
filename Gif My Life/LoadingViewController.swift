//
//  LoadingViewController.swift
//  Gif My Life
//
//  Created by Ali Kayhan on 23/05/2017.
//  Copyright © 2017 Ali Kayhan. All rights reserved.
//

import UIKit
import NVActivityIndicatorView
import SwifterSwift
import CoreData

class LoadingViewController: PortraitUIViewController {
    
    // MARK: - Properties
    var viewControllerStack = [UIViewController]()
    var activityIndicator: NVActivityIndicatorView!
    var stack: CoreDataStack!

    override var prefersStatusBarHidden: Bool {
        return true
    }    
    
    // MARK: - Lifecycle Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        stack = appDelegate.stack
        
        view.backgroundColor = UIConstants.Color.GMLPink
        activityIndicator = ActivityIndicator(on: view).indicator
        activityIndicator.startAnimating()
        
        createGifStack()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    // MARK: - Methods
    fileprivate func addLogo(on view: UIView) {
        let logoView = UIImageView(frame: CGRect(x: 0, y: 0, width: 150, height: 150))
        let logoImage = UIImage(named: "Placeholder")
        logoView.layer.borderWidth = 1.0
        logoView.layer.masksToBounds = false
        logoView.layer.borderColor = UIConstants.Color.GMLPink?.cgColor
        logoView.layer.cornerRadius = logoView.frame.size.width/2
        logoView.clipsToBounds = true
        
        logoView.image = logoImage
        
        logoView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(logoView)
        
        logoView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        logoView.topAnchor.constraint(equalTo: view.topAnchor, constant: 40).isActive = true
        logoView.widthAnchor.constraint(equalToConstant: 150).isActive = true
        logoView.heightAnchor.constraint(equalToConstant: 150).isActive = true
    }

    fileprivate func addLabel(on view: UIView) {
        let loadingLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 100))
        loadingLabel.text = UIConstants.Label.Loading
        loadingLabel.translatesAutoresizingMaskIntoConstraints = false
        loadingLabel.lineBreakMode = .byWordWrapping
        loadingLabel.numberOfLines = 0
        loadingLabel.textAlignment = .center
        loadingLabel.textColor = .white
        
        view.addSubview(loadingLabel)
        
        loadingLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        loadingLabel.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -40).isActive = true
        loadingLabel.widthAnchor.constraint(equalToConstant: 200).isActive = true
    }

    fileprivate func createGifStack() {
        GfycatClient().shared.getToken() { (token, error) in
            if let token = token as? String {
                GfycatClient().shared.token = token
                
                guard let userData = UserManager().shared.userData else {
                    self.createGifStackWithNoUserData()
                    return
                }
                
                guard let selectedCategories = userData[FirebaseClient.DatabaseKeys.SelectedCategories] as? [String: Any] else {
                    self.createGifStackWithNoUserData()
                    return
                }
                
                guard let keyword = selectedCategories.first?.key else {
                    self.createGifStackWithNoUserData()
                    return
                }

                GfycatClient().shared.search(gifsFor: keyword, andHandleCompletionWith: { (gifs, error) in
                    if let gifs = gifs as? [Gif] {
                        for gif in gifs {
                            let viewController = GifViewController.init(with: gif, isSwipeable: true)
                            self.viewControllerStack.append(viewController)
                        }
                        
                        // Create an instance of SwipeViewController and present it
                        let swipeViewController = SwipeViewController()
                        swipeViewController.viewControllerStack = self.viewControllerStack
                        self.present(swipeViewController, animated: true, completion: nil)
                        self.activityIndicator.stopAnimating()
                    }
                })
            } else {
                let downloadedGifs = GifManager().shared.downloadedGifs
                var gifs = [Gif]()
                
                if !downloadedGifs.isEmpty {
                    for downloadedGif in downloadedGifs {
                        gifs.append(GifManager().shared.createGifObject(from: downloadedGif))
                    }
                    
                    for gif in gifs {
                        let viewController = GifViewController.init(with: gif, isSwipeable: true)
                        self.viewControllerStack.append(viewController)
                        
                        // Create an instance of SwipeViewController and present it
                        let swipeViewController = SwipeViewController()
                        swipeViewController.viewControllerStack = self.viewControllerStack
                        self.present(swipeViewController, animated: true, completion: nil)
                        self.activityIndicator.stopAnimating()
                    }
                }
            }
        }
    }

    fileprivate func createGifStackWithNoUserData() {
        GfycatClient().shared.getAlgorithmicallyTrending(gifsFor: FirebaseClient.DatabaseKeys.DefaultCategoryID) { (gifs, error) in
            if let gifs = gifs as? [Gif] {
                for gif in gifs {
                    let viewController = GifViewController.init(with: gif, isSwipeable: true)
                    self.viewControllerStack.append(viewController)
                }

                // Create an instance of SwipeViewController and present it
                let swipeViewController = SwipeViewController()
                swipeViewController.viewControllerStack = self.viewControllerStack
                self.present(swipeViewController, animated: true, completion: nil)
                self.activityIndicator.stopAnimating()
            }
        }
    }

    override func updateViewConstraints() {
        addLogo(on: view)
        addLabel(on: view)
        super.updateViewConstraints()
    }
}
