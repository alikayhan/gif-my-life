//
//  FirebaseConstants.swift
//  Gif My Life
//
//  Created by Ali Kayhan on 24/06/2017.
//  Copyright © 2017 Ali Kayhan. All rights reserved.
//

// MARK: - FirebaseClient (Constants)

extension FirebaseClient {

    struct ErrorCodes {
        static let EmailAlreadyInUse: Int = 17007
    }

    struct DatabaseKeys {
        static let Users = "users"
        static let UID = "uID"
        static let Username = "username"
        static let Email = "email"
        static let EmailVerified = "emailVerified"
        static let Gender = "gender"
        static let PictureDataURL = "pictureDataURL"
        
        static let Usernames = "usernames"
        
        static let UserLikedGifs = "userLikedGifs"
        static let LikedGifs = "likedGifs"
        static let LikedAt = "likedAt"
        
        static let UserSelectedCategories = "userSelectedCategories"
        static let SelectedCategories = "selectedCategories"
        static let SelectedAt = "selectedAt"
        
        static let Categories = "categories"
        static let ID = "id"
        static let DisplayText = "displayText"
        static let Keyword = "keyword"
        static let Order = "order"
        static let Sponsored = "isSponsored"
        static let Default = "isDefault"
        static let DefaultCategoryID = "trending"
        
        static let CategoryUsers = "categoryUsers"
    }
}
