//
//  UserManager.swift
//  Gif My Life
//
//  Created by Ali Kayhan on 25/06/2017.
//  Copyright © 2017 Ali Kayhan. All rights reserved.
//

import Foundation
import Firebase

class UserManager: NSObject {
    
    // MARK: - Properties
    var user: User!
    var username: String!
    var userData: [String: Any]!
    var facebookProfileData: [String: Any]!
    
    // Shared instance
    var shared: UserManager {
        get {
            struct Singleton {
                static var sharedInstance = UserManager()
            }
            return Singleton.sharedInstance
        }
    }
    
    // MARK: - Methods
    func createUserData() {
        var dataToSave: [String: Any] = [FirebaseClient.DatabaseKeys.UID: user.uid,
                                         FirebaseClient.DatabaseKeys.Email: user.email ?? "",
                                         FirebaseClient.DatabaseKeys.EmailVerified: false,
                                         FirebaseClient.DatabaseKeys.Gender: "",
                                         FirebaseClient.DatabaseKeys.PictureDataURL: ""]
        
        if facebookProfileData != nil {
            if let gender = facebookProfileData[FacebookClient.GraphRequestParameterValues.Gender] as? String {
                dataToSave[FirebaseClient.DatabaseKeys.Gender] = gender
            }
            
            guard let picture = facebookProfileData[FacebookClient.GraphRequestResultKeys.Picture] as? [String: Any] else {
                return
            }
            
            if let pictureData = picture[FacebookClient.GraphRequestResultKeys.Data] as? [String: Any] {
                guard let pictureDataURL = pictureData[FacebookClient.GraphRequestResultKeys.URL] as? String else {
                    return
                }
                
                dataToSave[FirebaseClient.DatabaseKeys.PictureDataURL] = pictureDataURL
            }
        }
        
        if !CategoriesManager().shared.categoriesArray.isEmpty {
            for category in CategoriesManager().shared.categoriesArray {
                if category.isDefault {
                    dataToSave[FirebaseClient.DatabaseKeys.SelectedCategories] = [category.id: [FirebaseClient.DatabaseKeys.SelectedAt: FirebaseClient().shared.serverTimestamp]]
                }
            }
        } else {
            dataToSave[FirebaseClient.DatabaseKeys.SelectedCategories] = [FirebaseClient.DatabaseKeys.DefaultCategoryID: [FirebaseClient.DatabaseKeys.SelectedAt: FirebaseClient().shared.serverTimestamp]]
        }
        
        if let username = username {
            dataToSave[FirebaseClient.DatabaseKeys.Username] = username
            FirebaseClient().shared.save(dataToSave, to: "\(FirebaseClient.DatabaseKeys.Usernames)/\(username)")
        }

        userData = dataToSave
        FirebaseClient().shared.save(dataToSave, to: "\(FirebaseClient.DatabaseKeys.Users)/\(user.uid)")
    }

    func obtainUserData() {
        FirebaseClient().shared.readData(at: "\(FirebaseClient.DatabaseKeys.Users)/\(user.uid)") { (snapshot) in
            guard let snapshot = snapshot as DataSnapshot? else {
                self.createUserData()
                return
            }
            
            guard let data = snapshot.value as? [String: Any] else {
                self.createUserData()
                return
            }
            
            self.userData = data
            
            // If user has a username, assign it to username property.
            if let username = self.userData[FirebaseClient.DatabaseKeys.Username] as? String {
                self.username = username
            }
            
            // When a user signs up, its user ID stays same so readData returns valid userData.
            // This causes that createUserData has never been called when user has a valid username
            // and email. In order to be able to call createUserData(), this condition should be checked.
            if self.user.email != nil && self.userData[FirebaseClient.DatabaseKeys.Email] as? String == "" {
                self.createUserData()
            }
            
            if self.facebookProfileData != nil {
                if let gender = self.facebookProfileData[FacebookClient.GraphRequestParameterValues.Gender] as? String {
                    self.userData[FirebaseClient.DatabaseKeys.Gender] = gender
                }
                
                guard let picture = self.facebookProfileData[FacebookClient.GraphRequestResultKeys.Picture] as? [String: Any] else {
                    return
                }
                
                if let pictureData = picture[FacebookClient.GraphRequestResultKeys.Data] as? [String: Any] {
                    guard let pictureDataURL = pictureData[FacebookClient.GraphRequestResultKeys.URL] as? String else {
                        return
                    }
                    
                    self.userData[FirebaseClient.DatabaseKeys.PictureDataURL] = pictureDataURL
                }
                
                FirebaseClient().shared.save(self.userData, to: "\(FirebaseClient.DatabaseKeys.Users)/\(self.user.uid)")
            } else {
                // Because of Firebase persistence, obtainUserData never returns a nil snapshot once a user is created.
                // Persisted user data is sent to Firebase back, in case data on Firebase somehow gets deleted.
                FirebaseClient().shared.save(self.userData, to: "\(FirebaseClient.DatabaseKeys.Users)/\(self.user.uid)")
            }
        }
    }

    func setInitialUserState() {
        // Check if user has already signed in
        FirebaseClient().shared.checkUserLoginStatus { (user) in
            guard let user = user else {
                // If there is no signed in user, sign the current user anonymously
                FirebaseClient().shared.signInAnonymously { (user, error) in
                    guard let user = user else {
                        return
                    }
                    // Assign user to user property of shared instance
                    self.shared.user = user
                    // Create user data for anonymously signed-in user
                    self.createUserData()
                }
                
                return
            }
            
            // If there is a signed in user, assign it to user property of shared instance
            self.shared.user = user
            self.obtainUserData()
        }
    }
}
