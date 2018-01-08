//
//  SavedGifsViewController.swift
//  Gif My Life
//
//  Created by Ali Kayhan on 18/06/2017.
//  Copyright © 2017 Ali Kayhan. All rights reserved.
//

import UIKit
import CoreData
import SwiftGifOrigin

class SavedGifsViewController: PortraitUIViewController {
    
    // MARK: - Properties
    var stack: CoreDataStack!
    var gifCollectionView: UICollectionView!
    var blockOperations: [BlockOperation] = []
    var flowLayout: UICollectionViewFlowLayout!
    var emptyStateView: EmptyStateView!
    
    var fetchedResultsController : NSFetchedResultsController<NSFetchRequestResult>? {
        didSet {
            // Whenever the frc changes, we execute the search and
            // reload the collection view
            fetchedResultsController?.delegate = self
            executeSearch()
            gifCollectionView?.reloadData()
        }
    }
    
    // MARK: - Deinitializer
    deinit {
        blockOperations.forEach { $0.cancel() }
        blockOperations.removeAll(keepingCapacity: false)
    }
    
    // MARK: - Lifecycle Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIConstants.Color.GMLLightPurple
        addGifCollectionView(on: view)
        configureEmptyState()
        
        // Set the title to display on navigation bar
        navigationItem.title = UIConstants.Title.ViewController.SavedGifs
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        stack = appDelegate.stack
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let fc = fetchedResultsController {
            gifCollectionView.isHidden = (fc.fetchedObjects?.count == 0)
            emptyStateView.isHidden = !(fc.fetchedObjects?.count == 0)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    // This method is automatically called when the view transitions to another
    // size and it invalidates the layout of the collection view.
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        flowLayout.invalidateLayout()
    }
    
    // MARK: - Setup View Methods
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
        emptyStateView = EmptyStateView(frame: view.frame, icon: UIImage(named:"Download-EmptyState")!, text: UIConstants.Label.EmptyState.SavedGifs)
        emptyStateView.place(on: view)
    }
}

// MARK: - SavedGifsViewController (UICollectionViewDataSource)

extension SavedGifsViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let fc = fetchedResultsController {
            return fc.sections![section].numberOfObjects
        } else {
            return 0
        }
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
        
        if let downloadedGif = self.fetchedResultsController?.object(at: indexPath) as? DownloadedGif {
            cell.downloadedGif = downloadedGif
            if let posterImageData = downloadedGif.posterImage {
                DispatchQueue.main.async {
                     cell.imageView.image = UIImage(data: posterImageData as Data)
                }
            }
            cell.activityIndicator.stopAnimating()
        } else {
            cell.activityIndicator.stopAnimating()
        }
        
        return cell
    }
}


// MARK: - SavedGifsViewController (UICollectionViewDelegate)

extension SavedGifsViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? GifCollectionViewCell else {
            return
        }
        
        let gifViewController = GifViewController.init(with: GifManager().shared.createGifObject(from: cell.downloadedGif), andWith: cell.downloadedGif, isSwipeable: false)
        
        present(gifViewController, animated: true, completion: nil)
    }
}


// MARK: - SavedGifsViewController (UICollectionViewDelegateFlowLayout)

extension SavedGifsViewController: UICollectionViewDelegateFlowLayout {
    
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

// MARK: - PhotoAlbumViewController (NSFetchedResultsControllerDelegate)

extension SavedGifsViewController: NSFetchedResultsControllerDelegate {
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        blockOperations.removeAll(keepingCapacity: false)
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        
        switch type {
        case .insert:
            guard let newIndexPath = newIndexPath else { return }
            let op = BlockOperation { [weak self] in self?.gifCollectionView.insertItems(at: [newIndexPath]) }
            blockOperations.append(op)
            
        case .update:
            guard let newIndexPath = newIndexPath else { return }
            let op = BlockOperation { [weak self] in self?.gifCollectionView.reloadItems(at: [newIndexPath]) }
            blockOperations.append(op)
            
        case .move:
            guard let indexPath = indexPath else { return }
            guard let newIndexPath = newIndexPath else { return }
            let op = BlockOperation { [weak self] in self?.gifCollectionView.moveItem(at: indexPath, to: newIndexPath) }
            blockOperations.append(op)
            
        case .delete:
            guard let indexPath = indexPath else { return }
            let op = BlockOperation { [weak self] in self?.gifCollectionView.deleteItems(at: [indexPath]) }
            blockOperations.append(op)
        }
    }
    
    func controller(controller: NSFetchedResultsController<NSFetchRequestResult>, didChangeSection sectionInfo: NSFetchedResultsSectionInfo, atIndex sectionIndex: Int, forChangeType type: NSFetchedResultsChangeType) {
        
        switch type {
        case .insert:
            let op = BlockOperation { [weak self] in self?.gifCollectionView.insertSections(NSIndexSet(index: sectionIndex) as IndexSet) }
            blockOperations.append(op)
            
        case .update:
            let op = BlockOperation { [weak self] in self?.gifCollectionView.reloadSections(NSIndexSet(index: sectionIndex) as IndexSet) }
            blockOperations.append(op)
            
        case .delete:
            let op = BlockOperation { [weak self] in self?.gifCollectionView.deleteSections(NSIndexSet(index: sectionIndex) as IndexSet) }
            blockOperations.append(op)
            
        default: break
            
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        gifCollectionView.performBatchUpdates({
            self.blockOperations.forEach { $0.start() }
        }, completion: { finished in
            self.blockOperations.removeAll(keepingCapacity: false)
        })
    }
}

// MARK: - SavedGifsViewController (Execute Search)

extension SavedGifsViewController {
    func executeSearch() {
        if let fc = fetchedResultsController {
            do {
                try fc.performFetch()
            } catch let e as NSError {
                print("Error while trying to perform a search: \n\(e)\n\(String(describing: fetchedResultsController))")
            }
        }
    }
}
