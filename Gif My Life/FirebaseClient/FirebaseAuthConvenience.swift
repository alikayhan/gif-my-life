//
//  FirebaseAuthConvenience.swift
//  Gif My Life
//
//  Created by Ali Kayhan on 24/06/2017.
//  Copyright © 2017 Ali Kayhan. All rights reserved.
//

import Foundation
import UIKit
import FirebaseAuth

// MARK: - FirebaseClient (Convenient Resource Methods - Authentication)

extension FirebaseClient {
    
    // MARK: - Convenient Resource Methods - Authentication
    func checkUserLoginStatus(andHandleCompletionWith completionHandler: @escaping (User?) -> Void) {
        Auth.auth().addStateDidChangeListener { (auth, user) in
            guard let user = user else {
                completionHandler(nil)
                return
            }
            
            completionHandler(user)
        }
    }

    func signInAnonymously(andHandleCompletionWith completionHandler: @escaping (User?, NSError?) -> Void) {
        Auth.auth().signInAnonymously { (user, error) in
            guard let user = user else {
                if let error = error {
                    completionHandler(nil, error as NSError)
                } else {
                    completionHandler(nil, nil)
                }
                return
            }
            
            completionHandler(user, nil)
        }
    }

    func signIn(with email: String, and password: String, andHandleCompletionWith completionHandler: @escaping (User?, NSError?) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
            guard let user = user else {
                if let error = error {
                    completionHandler(nil, error as NSError)
                } else {
                    completionHandler(nil, nil)
                }
                return
            }
            
            completionHandler(user, nil)
        }
    }
    
    func signInWithFacebook(with readPermissions: [String], from viewController: UIViewController, andHandleCompletionWith completionHandler: @escaping (User?, NSError?) -> Void) {
        FacebookClient().shared.login(with: readPermissions, from: viewController) { (tokenString, error) in
            guard let tokenString = tokenString else {
                if let error = error {
                    completionHandler(nil, error)
                } else {
                    completionHandler(nil, nil)
                }
                return
            }
            
            Auth.auth().signIn(with: FacebookAuthProvider.credential(withAccessToken: tokenString)) { (user, error) in
                guard let user = user else {
                    if let error = error {
                        completionHandler(nil, error as NSError)
                    } else {
                        completionHandler(nil, nil)
                    }
                    return
                }
                
                completionHandler(user, nil)
            }
        }        
    }

    func signUp(with email: String, and password: String, andHandleCompletionWith completionHandler: @escaping (User?, NSError?) -> Void) {
        let credential = EmailAuthProvider.credential(withEmail: email, password: password)
        
        getCurrentUser { (user) in
            guard let user = user else {
                completionHandler(nil, nil)
                return
            }
            
            user.link(with: credential) { (user, error) in
                guard let user = user else {
                    if let error = error {
                        completionHandler(nil, error as NSError)
                    } else {
                        completionHandler(nil, nil)
                    }
                    return
                }
                
                completionHandler(user, nil)
            }
        }
    }

    func signUpWithFacebook(with readPermissions: [String], from viewController: UIViewController, andHandleCompletionWith completionHandler: @escaping (User?, NSError?) -> Void) {
        FacebookClient().shared.login(with: readPermissions, from: viewController) { (tokenString, error) in
            guard let tokenString = tokenString else {
                if let error = error {
                    completionHandler(nil, error)
                } else {
                    completionHandler(nil, nil)
                }
                return
            }
            
            let credential = FacebookAuthProvider.credential(withAccessToken: tokenString)
            
            self.getCurrentUser() { (user) in
                guard let user = user else {
                    completionHandler(nil, nil)
                    return
                }
                
                user.link(with: credential) { (user, error) in
                    guard let user = user else {
                        if let error = error {
                            completionHandler(nil, error as NSError)
                        } else {
                            completionHandler(nil, nil)
                        }
                        return
                    }
                    
                    completionHandler(user, nil)
                }
            }
        }
    }

    func changeUserProfile(by changeRequest: UserProfileChangeRequest, andHandleCompletionWith completionHandler: @escaping (NSError?) -> Void) {
        changeRequest.commitChanges { (error) in
            if let error = error {
                completionHandler(error as NSError)
            } else {
                completionHandler(nil)
            }
        }
    }

    func updateEmail(to email: String, andHandleCompletionWith completionHandler: @escaping (NSError?) -> Void) {
        Auth.auth().currentUser?.updateEmail(to: email) { (error) in
            if let error = error {
                completionHandler(error as NSError)
            } else {
                completionHandler(nil)
            }
        }
    }

    func updatePassword(to password: String, andHandleCompletionWith completionHandler: @escaping (NSError?) -> Void) {
        Auth.auth().currentUser?.updatePassword(to: password) { (error) in
            if let error = error {
                completionHandler(error as NSError)
            } else {
                completionHandler(nil)
            }
        }
    }

    func sendPasswordResetLink(to email: String, andHandleCompletionWith completionHandler: @escaping (NSError?) -> Void) {
        Auth.auth().sendPasswordReset(withEmail: email) { (error) in
            if let error = error {
                completionHandler(error as NSError)
            } else {
                completionHandler(nil)
            }
        }
    }

    func signOut(andHandleCompletionWith completionHandler: @escaping (NSError?) -> Void) {
        do {
            try Auth.auth().signOut()
            completionHandler(nil)
        } catch {
            completionHandler(error as NSError)
        }
    }

    func returnErrorCode(for error: NSError, andHandleCompletionWith completionHandler: @escaping (AuthErrorCode?) -> Void) {
        guard let errorCode = AuthErrorCode(rawValue: error.code) else {
            completionHandler(nil)
            return
        }
        
        completionHandler(errorCode)
    }

    func getCurrentUser(andHandleCompletionWith completionHandler: @escaping (User?) -> Void) {
        Auth.auth().addStateDidChangeListener { (auth, user) in
            guard let user = user else {
                completionHandler(nil)
                return
            }
            
            completionHandler(user)
        }
    }
}
