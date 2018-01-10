//
//  GifViewController.swift
//  Gif My Life
//
//  Created by Ali Kayhan on 05/06/2017.
//  Copyright © 2017 Ali Kayhan. All rights reserved.
//

import UIKit
import NVActivityIndicatorView
import SwiftGifOrigin
import SwifterSwift
import CoreData

class GifViewController: UIViewController {
    
    // MARK: - Properties
    var gifView = UIImageView()
    var gifImage : UIImage = UIImage()
    var gifData: Data!
    var gif: Gif!
    var downloadedGif: DownloadedGif!
    var stack: CoreDataStack!
    
    var activityIndicator: NVActivityIndicatorView!
    var isFirstAppearance = true
    var isSwipeable: Bool!
    
    var downloadButton: UIButton!
    var likeButton: UIButton!
    var shareButton: UIButton!
    var userProfileButton: UIButton!
    var upperLeftButton: UIButton!
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    // MARK: - Initializers
    convenience init(with gif: Gif, andWith downloadedGif: DownloadedGif? = nil, isSwipeable: Bool) {
        self.init()
        
        self.gif = gif
        
        if downloadedGif != nil {
            self.downloadedGif = downloadedGif
        }
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        self.stack = appDelegate.stack

        self.isSwipeable = isSwipeable
    }
    
    // MARK: - Lifecycle Functions   
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if isFirstAppearance {
            configureGifView()
        } else {
            setupDownloadButton()
            setupLikeButton()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        isFirstAppearance = false
        
        // Check the network reachability
        if !(NetworkManager().shared.hasConnectivity()) {
            showAlert(with: UIConstants.Error.NoInternetConnection)
            activityIndicator.stopAnimating()
        }
    }
    
    // MARK: - Configure Gif View
    fileprivate func configureGifView() {
        gifView.translatesAutoresizingMaskIntoConstraints = false
        gifView.contentMode = .scaleAspectFit
        gifView.clipsToBounds = true
        
        view.addSubview(gifView)
        
        let centerXConstraint = NSLayoutConstraint(item: gifView, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1, constant: 0)
        let centerYConstraint = NSLayoutConstraint(item: gifView, attribute: .centerY, relatedBy: .equal, toItem: view, attribute: .centerY, multiplier: 1, constant: 0)
        
        let widthConstraint = NSLayoutConstraint(item: gifView, attribute: .width, relatedBy: .equal, toItem: view, attribute: .width, multiplier: 1, constant: 0)
        let heightConstraint = NSLayoutConstraint(item: gifView, attribute: .height, relatedBy: .equal, toItem: view, attribute: .height, multiplier: 1, constant: 0)
        
        view.addConstraints([centerXConstraint, centerYConstraint, widthConstraint, heightConstraint])
        
        activityIndicator = ActivityIndicator(on: view).indicator
        
        DispatchQueue.main.async {
            self.activityIndicator.startAnimating()
        }
        
        if downloadedGif != nil {
            view.backgroundColor = UIColor.init(hexString: downloadedGif.avgColor!)
            gifView.image = UIImage.gif(data: downloadedGif.gifData! as Data)
            
            DispatchQueue.main.async {
                self.activityIndicator.stopAnimating()
                self.downloadButton.isEnabled = true
            }
        } else {
            view.backgroundColor = UIColor.init(hexString: gif.avgColor)
            
            DispatchQueue.global(qos: .default).async {
                GfycatClient().shared.downloadImage(with: self.gif.mobilePosterURL) { (imageData) in
                    if let imageData = imageData as? Data {
                        DispatchQueue.main.async {
                            self.gifView.image = UIImage(data: imageData)
                            
                            DispatchQueue.global(qos: .default).async {
                                do {
                                    self.gifData = try Data(contentsOf: URL(string: self.gif.max2MbURL)!)
                                    
                                    guard let gifImage = UIImage.gif(data: self.gifData) else {
                                        return
                                    }
                                    
                                    self.gifImage = gifImage
                                    DispatchQueue.main.async {
                                        self.gifView.image = self.gifImage
                                        self.activityIndicator.stopAnimating()
                                        self.downloadButton.isEnabled = true
                                    }
                                } catch {
                                    print(error.localizedDescription)
                                    self.showAlert(with: UIConstants.Error.DownloadFailed)
                                    self.activityIndicator.stopAnimating()
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    // MARK: - Add Buttons
    fileprivate func addButtons(on view: UIView) {
        setupUpperLeftButton()
        setupDownloadButton()
        setupLikeButton()
        setupShareButton()
        
        var buttons = [downloadButton, likeButton, shareButton, upperLeftButton]
        
        if isSwipeable {
            setupUserProfileButton()
            buttons.append(userProfileButton)
        }
        
        for button in buttons {
            guard let button = button else {
                return
            }
            
            view.addSubview(button)
        }
        
        setConstraintsForUpperLeftButton()
        setConstraintsForDownloadButton()
        setConstraintsForLikeButton()
        setConstraintsForShareButton()
        
        if isSwipeable {
            setConstraintsForUserProfileButton()
        }
    }
    
    // MARK: - Add Buttons Setup Methods
    fileprivate func setupUserProfileButton() {
        userProfileButton = UIButton(frame: CGRect(x: 0, y: 0, width: 44, height: 44))
        userProfileButton.setImage(UIImage(named: "You"), for: .normal)
        userProfileButton.tintColor = UIColor.init(hexString: gif.avgColor)?.complementary
        userProfileButton.addTarget(self, action: #selector(presentUserProfileViewController), for: .touchUpInside)
        userProfileButton.translatesAutoresizingMaskIntoConstraints = false
    }
    
    fileprivate func setConstraintsForUserProfileButton() {
        let margins = view.layoutMarginsGuide
        
        userProfileButton.topAnchor.constraint(equalTo: margins.topAnchor, constant: 20).isActive = true
        userProfileButton.trailingAnchor.constraint(equalTo: margins.trailingAnchor).isActive = true
    }

    fileprivate func setupDownloadButton() {
        
        if downloadButton == nil {
            downloadButton = UIButton(frame: CGRect(x: 0, y: 0, width: 44, height: 44))
            downloadButton.tintColor = UIColor.init(hexString: gif.avgColor)?.complementary
            downloadButton.translatesAutoresizingMaskIntoConstraints = false
            downloadButton.isEnabled = false
        }

        if GifManager().shared.downloadedGifsIDs.contains(gif.id) {
            downloadButton.setImage(UIImage(named: "Download-Filled"), for: .normal)
            downloadButton.removeTarget(self, action: #selector(downloadGif), for: .touchUpInside)
            downloadButton.addTarget(self, action: #selector(deleteDownloadedGif), for: .touchUpInside)
        } else {
            downloadButton.setImage(UIImage(named: "Download"), for: .normal)
            downloadButton.removeTarget(self, action: #selector(deleteDownloadedGif), for: .touchUpInside)
            downloadButton.addTarget(self, action: #selector(downloadGif), for: .touchUpInside)
        }
    }
    
    fileprivate func setConstraintsForDownloadButton() {
        let margins = view.layoutMarginsGuide
        
        downloadButton.bottomAnchor.constraint(equalTo: margins.bottomAnchor, constant: -30).isActive = true
        downloadButton.leadingAnchor.constraint(equalTo: margins.leadingAnchor).isActive = true
    }

    fileprivate func setupShareButton() {
        shareButton = UIButton(frame: CGRect(x: 0, y: 0, width: 44, height: 44))
        shareButton.setImage(UIImage(named: "Share"), for: .normal)
        shareButton.tintColor = UIColor.init(hexString: gif.avgColor)?.complementary
        shareButton.addTarget(self, action: #selector(shareGif), for: .touchUpInside)
        shareButton.translatesAutoresizingMaskIntoConstraints = false
    }
    
    fileprivate func setConstraintsForShareButton() {
        let margins = view.layoutMarginsGuide
        
        shareButton.bottomAnchor.constraint(equalTo: margins.bottomAnchor, constant: -30).isActive = true
        shareButton.trailingAnchor.constraint(equalTo: margins.trailingAnchor).isActive = true
    }

    fileprivate func setupLikeButton() {
        if likeButton == nil {
            likeButton = UIButton(frame: CGRect(x: 0, y: 0, width: 44, height: 44))
            likeButton.tintColor = UIColor.init(hexString: gif.avgColor)?.complementary
            likeButton.translatesAutoresizingMaskIntoConstraints = false
        }
        
        guard let likedGifs = UserManager().shared.userData[FirebaseClient.DatabaseKeys.LikedGifs] as? [String: Any] else {
            likeButton.setImage(UIImage(named: "Like"), for: .normal)
            likeButton.addTarget(self, action: #selector(likeGif), for: .touchUpInside)
            return
        }
            
        guard let gifID = gif.id else {
            return
        }
        
        if likedGifs[gifID] == nil {
            likeButton.setImage(UIImage(named: "Like"), for: .normal)
            likeButton.removeTarget(self, action: #selector(unlikeGif), for: .touchUpInside)
            likeButton.addTarget(self, action: #selector(likeGif), for: .touchUpInside)
        } else {
            likeButton.setImage(UIImage(named: "Like-Filled"), for: .normal)
            likeButton.removeTarget(self, action: #selector(likeGif), for: .touchUpInside)
            likeButton.addTarget(self, action: #selector(unlikeGif), for: .touchUpInside)
        }
    }
    
    fileprivate func setConstraintsForLikeButton() {
        let margins = view.layoutMarginsGuide
        
        likeButton.bottomAnchor.constraint(equalTo: margins.bottomAnchor, constant: -30).isActive = true
        likeButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    }

    // Upper Left button is GifMyLife logo when displayed view controller is 
    // swipeable (i.e. in a GifViewController stack) and a Dismiss icon when
    // a single gif is being displayed
    fileprivate func setupUpperLeftButton() {
        upperLeftButton = UIButton(frame: CGRect(x: 0, y: 0, width: 44, height: 44))
        upperLeftButton.translatesAutoresizingMaskIntoConstraints = false
        
        if isSwipeable {
            upperLeftButton.setImage(UIImage(named: "GML"), for: .normal)
        } else {
            upperLeftButton.setImage(UIImage(named: "Dismiss"), for: .normal)
            upperLeftButton.tintColor = UIColor.init(hexString: gif.avgColor)?.complementary
            upperLeftButton.addTarget(self, action: #selector(dismissViewController), for: .touchUpInside)
        }
    }
    
    fileprivate func setConstraintsForUpperLeftButton() {
        let margins = view.layoutMarginsGuide
        if isSwipeable {
            upperLeftButton.topAnchor.constraint(equalTo: margins.topAnchor, constant: 17).isActive = true
        } else {
            upperLeftButton.topAnchor.constraint(equalTo: margins.topAnchor, constant: 20).isActive = true
        }
        
        upperLeftButton.leadingAnchor.constraint(equalTo: margins.leadingAnchor).isActive = true
    }
    
    // MARK: - Selectors
    @objc fileprivate func presentUserProfileViewController() {
        let userProfileViewController = UserProfileViewController()
        let userProfileViewControllerNavigation = UINavigationController(rootViewController: userProfileViewController)
        
        self.present(userProfileViewControllerNavigation, animated: true)
    }
    
    @objc fileprivate func dismissViewController() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc fileprivate func shareGif() {
        var dataToShare: Data!
        var fileURL: URL!
        
        let activityData = ActivityData(type: .ballGridPulse, color: UIConstants.Color.GMLPurple)
        NVActivityIndicatorPresenter.sharedInstance.startAnimating(activityData)
        
        DispatchQueue.global(qos: .default).async {
            do {
                dataToShare = try Data(contentsOf: URL(string: self.gif.max2MbURL)!)
            } catch {
                fileURL = URL(string: self.gif.max2MbURL)
            }
            
            do {
                let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
                fileURL = documentsURL.appendingPathComponent("GifMyLife.gif")
                try dataToShare.write(to: fileURL, options: .atomic)
            } catch {
            }
            
            let activityViewController = UIActivityViewController(activityItems: [fileURL], applicationActivities: nil)
            activityViewController.popoverPresentationController?.sourceView = self.view
            activityViewController.excludedActivityTypes = [.airDrop, .assignToContact, .addToReadingList, .openInIBooks, .postToFlickr, .print, .copyToPasteboard, .postToTencentWeibo, .postToVimeo, .postToWeibo, .postToFacebook, .postToTwitter, .saveToCameraRoll]
            
            DispatchQueue.main.async {
                self.present(activityViewController, animated: true, completion: nil)
                NVActivityIndicatorPresenter.sharedInstance.stopAnimating()
            }
        }
    }
    
    @objc fileprivate func likeGif() {
        DispatchQueue.main.async {
            self.likeButton.setImage(UIImage(named: "Like-Filled"), for: .normal)
        }
        
        likeButton.removeTarget(self, action: #selector(likeGif), for: .touchUpInside)
        likeButton.addTarget(self, action: #selector(unlikeGif), for: .touchUpInside)
        
        guard let gifID = gif.id else {
            return
        }
        
        guard var dataPack = gif.dataPack else {
            return
        }
        
        dataPack[FirebaseClient.DatabaseKeys.LikedAt] = FirebaseClient().shared.serverTimestamp
        
        let childUpdates = ["\(FirebaseClient.DatabaseKeys.UserLikedGifs)/\(UserManager().shared.user.uid)/\(FirebaseClient.DatabaseKeys.LikedGifs)/\(gifID)": dataPack,
                            "\(FirebaseClient.DatabaseKeys.Users)/\(UserManager().shared.user.uid)/\(FirebaseClient.DatabaseKeys.LikedGifs)/\(gifID)/\(FirebaseClient.DatabaseKeys.LikedAt)": FirebaseClient().shared.serverTimestamp]
        
        FirebaseClient().shared.update(childValuesWith: childUpdates)
        
        
        guard var likedGifs = UserManager().shared.userData[FirebaseClient.DatabaseKeys.LikedGifs] as? [String: Any] else {
            UserManager().shared.userData[FirebaseClient.DatabaseKeys.LikedGifs] = [gifID: ["\(FirebaseClient.DatabaseKeys.LikedAt)": FirebaseClient().shared.serverTimestamp]]
            return
        }
        
        likedGifs[gifID] = ["\(FirebaseClient.DatabaseKeys.LikedAt)": FirebaseClient().shared.serverTimestamp]
        UserManager().shared.userData[FirebaseClient.DatabaseKeys.LikedGifs] = likedGifs
    }
    
    @objc fileprivate func unlikeGif() {
        DispatchQueue.main.async {
            self.likeButton.setImage(UIImage(named: "Like"), for: .normal)
        }
        
        likeButton.removeTarget(self, action: #selector(unlikeGif), for: .touchUpInside)
        likeButton.addTarget(self, action: #selector(likeGif), for: .touchUpInside)
        
        guard let gifID = gif.id else {
            return
        }
        
        let childUpdates = ["\(FirebaseClient.DatabaseKeys.UserLikedGifs)/\(UserManager().shared.user.uid)/\(FirebaseClient.DatabaseKeys.LikedGifs)/\(gifID)": [:],
                            "\(FirebaseClient.DatabaseKeys.Users)/\(UserManager().shared.user.uid)/\(FirebaseClient.DatabaseKeys.LikedGifs)/\(gifID)": [:]]
        
        FirebaseClient().shared.update(childValuesWith: childUpdates)
        
        guard var likedGifs = UserManager().shared.userData[FirebaseClient.DatabaseKeys.LikedGifs] as? [String: Any] else {
            return
        }
        
        likedGifs.removeAll(keys: [gifID])
        UserManager().shared.userData[FirebaseClient.DatabaseKeys.LikedGifs] = likedGifs
    }
    
    @objc fileprivate func downloadGif() {
        DispatchQueue.main.async {
            self.activityIndicator.startAnimating()
            self.downloadButton.isEnabled = false
        }
        
        downloadButton.removeTarget(self, action: #selector(downloadGif), for: .touchUpInside)
        downloadButton.addTarget(self, action: #selector(deleteDownloadedGif), for: .touchUpInside)
        
        let downloadedGif = NSEntityDescription.insertNewObject(forEntityName: "DownloadedGif", into: stack.context) as! DownloadedGif
        
        downloadedGif.uID = UserManager().shared.user.uid
        downloadedGif.id = gif.id
        downloadedGif.name = gif.name
        downloadedGif.number = gif.number
        downloadedGif.width = gif.width
        downloadedGif.height = gif.height
        downloadedGif.avgColor = gif.avgColor
        downloadedGif.createDate = gif.createDate
        downloadedGif.nsfw = gif.nsfw
        downloadedGif.tags = gif.tags as NSObject?
        downloadedGif.title = gif.title
        downloadedGif.desc = gif.description
        downloadedGif.gifURL = gif.gifURL
        downloadedGif.mobileURL = gif.mobileURL
        downloadedGif.mobilePosterURL = gif.mobilePosterURL
        downloadedGif.max1MbURL = gif.max1MbURL
        downloadedGif.max2MbURL = gif.max2MbURL
        downloadedGif.max5MbURL = gif.max5MbURL
        downloadedGif.downloadedAt = Date()
        downloadedGif.gifData = gifData
        
        GfycatClient().shared.downloadImage(with: self.gif.mobilePosterURL) { (imageData) in
            if let imageData = imageData as? Data {
                downloadedGif.posterImage = imageData
                
                // In order not to lose user data in a case of crash etc, context is saved immediately
                // without waiting for auto save.
                do {
                    try self.stack.saveContext()
                } catch {
                    print(error.localizedDescription)
                }
                
                DispatchQueue.main.async {
                    self.downloadButton.setImage(UIImage(named: "Download-Filled"), for: .normal)
                    self.activityIndicator.stopAnimating()
                    self.downloadButton.isEnabled = true
                }
            } else {
                // In order not to lose user data in a case of crash etc, context is saved immediately
                // without waiting for auto save.
                do {
                    try self.stack.saveContext()
                } catch {
                    print(error.localizedDescription)
                }
                
                DispatchQueue.main.async {
                    self.downloadButton.setImage(UIImage(named: "Download-Filled"), for: .normal)
                    self.activityIndicator.stopAnimating()
                    self.downloadButton.isEnabled = true
                }
            }
        }
    }
    
    @objc fileprivate func deleteDownloadedGif() {
        
        DispatchQueue.main.async {
            self.activityIndicator.startAnimating()
            self.downloadButton.isEnabled = false
        }
        
        downloadButton.removeTarget(self, action: #selector(deleteDownloadedGif), for: .touchUpInside)
        downloadButton.addTarget(self, action: #selector(downloadGif), for: .touchUpInside)

        let gifToDelete: DownloadedGif!
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "DownloadedGif")
        let predicate = NSPredicate(format: "id == %@", argumentArray: [gif.id])
        
        fetchRequest.predicate = predicate
        
        do {
            let results = try stack.context.fetch(fetchRequest) as? [DownloadedGif]
            gifToDelete = results![0]
        } catch {
            print(error.localizedDescription)
            return
        }
        
        stack.context.delete(gifToDelete)
        
        // Save context after downloaded gif is deleted
        do {
            try self.stack.saveContext()
        } catch {
            print(error.localizedDescription)
        }
        
        DispatchQueue.main.async {
            self.downloadButton.setImage(UIImage(named: "Download"), for: .normal)
            self.activityIndicator.stopAnimating()
            self.downloadButton.isEnabled = true
        }
    }
    
    // MARK: - Update View Constraints
    override func updateViewConstraints() {
        addButtons(on: view)
        super.updateViewConstraints()
    }
    
    // MARK: - Show Alert
    fileprivate func showAlert(with title: String, message: String? = nil) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: UIConstants.Title.AlertAction.OK, style: .default, handler: nil)
        alertController.addAction(okAction)
        
        present(alertController, animated: true, completion: nil)
    }
}
