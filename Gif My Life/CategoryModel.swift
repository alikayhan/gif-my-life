//
//  CategoryModel.swift
//  Gif My Life
//
//  Created by Ali Kayhan on 30/06/2017.
//  Copyright © 2017 Ali Kayhan. All rights reserved.
//

import Foundation

// MARK: - Category Model

// This struct is used to create Category objects after reading categories from Firebase
struct Category {
    
    // MARK: - Properties
    let id: String!
    let displayText: String!
    let keyword: String!
    let order: Int!
    let isSponsored: Bool!
    let isDefault: Bool!
    
    let dataPack: [String: Any]!
    
    // MARK: - Initializers
    
    // Construct a category object from a dictionary
    init(from dictionary: [String: Any]) {
        id = dictionary[FirebaseClient.DatabaseKeys.ID] as? String
        displayText = dictionary[FirebaseClient.DatabaseKeys.DisplayText] as? String
        keyword = dictionary[FirebaseClient.DatabaseKeys.Keyword] as? String
        order = dictionary[FirebaseClient.DatabaseKeys.Order] as? Int
        isSponsored = dictionary[FirebaseClient.DatabaseKeys.Sponsored] as? Bool
        isDefault = dictionary[FirebaseClient.DatabaseKeys.Default] as? Bool
        
        dataPack = [FirebaseClient.DatabaseKeys.ID: id,
                    FirebaseClient.DatabaseKeys.DisplayText: displayText,
                    FirebaseClient.DatabaseKeys.Keyword: keyword,
                    FirebaseClient.DatabaseKeys.Order: order,
                    FirebaseClient.DatabaseKeys.Sponsored: isSponsored,
                    FirebaseClient.DatabaseKeys.Default: isDefault]
    }
    
    // Construct a Categories array from snapshot
    static func categoriesArray(from results: [[String: Any]]) -> [Category] {
        var categoriesArray = [Category]()
        
        // Iterate through array of dictionaries where each dictionary represents a category
        for result in results {
            categoriesArray.append(Category(from: result))
        }
        
        return categoriesArray
    }  
}
