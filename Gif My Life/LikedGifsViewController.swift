//
//  LikedGifsViewController.swift
//  Gif My Life
//
//  Created by Ali Kayhan on 18/06/2017.
//  Copyright © 2017 Ali Kayhan. All rights reserved.
//

import UIKit
import Firebase

class LikedGifsViewController: PortraitUIViewController {
    
    // MARK: - Properties
    var stack: CoreDataStack!
    var gifCollectionView: UICollectionView!
    var flowLayout: UICollectionViewFlowLayout!
    var emptyStateView: EmptyStateView!
    
    var gifs = [DataSnapshot]()
    var gifSnapshot: DataSnapshot!
    
    // MARK: - Lifecycle Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIConstants.Color.GMLLightPurple
        addGifCollectionView(on: view)
        configureEmptyState()
        
        initialReading()
        listenForLikedGifs()
        listenForUnlikedGifs()
        
        // Set the title to display on navigation bar
        navigationItem.title = UIConstants.Title.ViewController.LikedGifs
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    // MARK: - Deinitializer
    deinit {
        FirebaseClient().shared.stopListeningForData(at: "\(FirebaseClient.DatabaseKeys.UserLikedGifs)")
    }
    
    // MARK: - Setup View Methods
    
    // This method is automatically called when the view transitions to another
    // size and it invalidates the layout of the collection view.
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        flowLayout.invalidateLayout()
    }
    
    fileprivate func addGifCollectionView(on view: UIView) {
        flowLayout = UICollectionViewFlowLayout()
        gifCollectionView = UICollectionView(frame: view.frame, collectionViewLayout: flowLayout)
        
        gifCollectionView.register(GifCollectionViewCell.self, forCellWithReuseIdentifier: "GifCell")
        gifCollectionView.dataSource = self
        gifCollectionView.delegate = self
        gifCollectionView.translatesAutoresizingMaskIntoConstraints = false
        gifCollectionView.backgroundColor = UIConstants.Color.GMLLightPurple
        view.addSubview(gifCollectionView)
        
        gifCollectionView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        gifCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        gifCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        gifCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
    }

    fileprivate func configureEmptyState() {
        // Initiate empty state view and place it on view
        emptyStateView = EmptyStateView(frame: view.frame, icon: UIImage(named:"Like-EmptyState")!, text: UIConstants.Label.EmptyState.LikedGifs)
        emptyStateView.place(on: view)
    }
    
    // MARK: - Firebase Methods
    fileprivate func initialReading() {
        FirebaseClient().shared.readData(at: "\(FirebaseClient.DatabaseKeys.UserLikedGifs)/\(UserManager().shared.user.uid)/\(FirebaseClient.DatabaseKeys.LikedGifs)") { (snapshot) in
            if !(snapshot.exists()) {
                DispatchQueue.main.async {
                    // Hide the collection view
                    self.gifCollectionView.isHidden = true
                    // Show empty state stack view
                    self.emptyStateView.isHidden = false
                }
            }
        }
    }
    
    fileprivate func listenForLikedGifs() {
        FirebaseClient().shared.listenForAddedData(at: "\(FirebaseClient.DatabaseKeys.UserLikedGifs)/\(UserManager().shared.user.uid)/\(FirebaseClient.DatabaseKeys.LikedGifs)", sortingBy: FirebaseClient.DatabaseKeys.LikedAt) { (snapshot) in
            
            // Instead of append, use prepend to add items in the reverse order
            // so that the most recent like will be placed at top
            self.gifs.append(snapshot)
            self.gifCollectionView.insertItems(at: [IndexPath(row: self.gifs.count-1, section: 0)])
            
            self.gifCollectionView.isHidden = self.gifs.isEmpty
            self.emptyStateView.isHidden = !self.gifs.isEmpty
        }
    }
    
    fileprivate func listenForUnlikedGifs() {
        FirebaseClient().shared.listenForRemovedData(at: "\(FirebaseClient.DatabaseKeys.UserLikedGifs)/\(UserManager().shared.user.uid)/\(FirebaseClient.DatabaseKeys.LikedGifs)") { (snapshot) in
            let index = self.index(of: snapshot)
            self.gifs.remove(at: index)
            self.gifCollectionView.deleteItems(at: [IndexPath(row: index, section: 0)])
            
            self.gifCollectionView.isHidden = self.gifs.isEmpty
            self.emptyStateView.isHidden = !self.gifs.isEmpty
        }
    }
    
    // MARK: - Helper Methods
    fileprivate func index(of gifSnapshot: DataSnapshot) -> Int {
        var index = 0
        for  gif in self.gifs {
            if (gifSnapshot.key == gif.key) {
                return index
            }
            index += 1
        }
        return -1
    }
        
}

// MARK: - LikedGifsViewController (UICollectionViewDataSource)

extension LikedGifsViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // Return the number of items
        return gifs.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let reuseIdentifier = "GifCell"
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! GifCollectionViewCell
        cell.backgroundColor = .gray
        cell.activityIndicator.startAnimating()
        
        // Add cell tag to check below while assigning cell.imageView's image
        // so that image flickering and wrong image displaying will not occur
        // due to cell reuse
        cell.tag = indexPath.item
        
        configure(cell, at: indexPath)
        return cell
    }
    
    fileprivate func configure(_ cell: GifCollectionViewCell, at indexPath: IndexPath) {
        // Unpack gif from Firebase data snapshot
        let itemSnapshot: DataSnapshot! = gifs[indexPath.row]
        guard let item = itemSnapshot.value as? [String: Any] else {
            return
        }
        
        // Configure cell image
        if let mobilePosterURL = item[GfycatClient.ResponseKeys.MobilePosterURL] as? String {
            GfycatClient().shared.downloadImage(with: mobilePosterURL) { (imageData) in
                DispatchQueue.main.async {
                    if cell.tag == indexPath.item {
                        cell.imageView.image = UIImage(data: imageData as! Data)
                        cell.activityIndicator.stopAnimating()
                    }
                }
            }
        } else {
            DispatchQueue.main.async {
                cell.imageView.image = UIImage(named: "Placeholder")
                cell.activityIndicator.stopAnimating()
            }
        }
    }
}


// MARK: - LikedGifsViewController (UICollectionViewDelegate)

extension LikedGifsViewController: UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        // Unpack gif from Firebase data snapshot
        let itemSnapshot: DataSnapshot! = gifs[indexPath.row]
        
        // Get Gif object created by Gif Manager
        guard let likedGif = GifManager().shared.createGifObject(from: itemSnapshot) else {
            return
        }
        
        let gifViewController = GifViewController(with: likedGif, isSwipeable: false)
        
        present(gifViewController, animated: true, completion: nil)
    }
}


// MARK: - LikedGifsViewController (UICollectionViewDelegateFlowLayout)

extension LikedGifsViewController: UICollectionViewDelegateFlowLayout {
    
    // This function is automatically called when the current flow layout is invalidated and
    // sets a new cell size appropriate to device's new orientation.
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return setupFlowLayout(spaceBetweenPhotoCells: CGFloat(UIConstants.Size.GifCollectionView.SpaceBetweenItems), photosInARow: UIConstants.Size.GifCollectionView.ItemsInARow).itemSize
    }
    
    // Helper function for setting flow layout up
    func setupFlowLayout(spaceBetweenPhotoCells: CGFloat, photosInARow: Int) -> UICollectionViewFlowLayout {
        let dimension = (view.frame.size.width - ((CGFloat(photosInARow - 1)) * spaceBetweenPhotoCells)) / CGFloat(photosInARow)
        
        flowLayout.minimumLineSpacing = spaceBetweenPhotoCells
        flowLayout.minimumInteritemSpacing = spaceBetweenPhotoCells
        flowLayout.itemSize = CGSize(width: dimension, height: dimension)
        
        return flowLayout
    }
}
