//
//  CategoriesManager.swift
//  Gif My Life
//
//  Created by Ali Kayhan on 30/06/2017.
//  Copyright © 2017 Ali Kayhan. All rights reserved.
//

import Foundation

class CategoriesManager: NSObject {
    
    // MARK: - Properties
    var categoriesArray = [Category]()
    
    // Shared instance
    var shared: CategoriesManager {
        get {
            struct Singleton {
                static var sharedInstance = CategoriesManager()
            }
            
            return Singleton.sharedInstance
        }
    }
    
    // MARK: - Methods
    func obtainCategories() {
        FirebaseClient().shared.readData(at: "\(FirebaseClient.DatabaseKeys.Categories)") { (snapshot) in
            guard let categoriesData = snapshot.value as? [String: Any] else {
                return
            }
            
            // Create categoriesArray by sorting the categories by the value of order property
            self.categoriesArray = Category.categoriesArray(from: Array(categoriesData.values) as! [[String: Any]]).sorted(by: {$0.order < $1.order})
        }
    }
}
