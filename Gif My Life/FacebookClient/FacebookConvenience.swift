//
//  FacebookConvenience.swift
//  Gif My Life
//
//  Created by Ali Kayhan on 24/06/2017.
//  Copyright © 2017 Ali Kayhan. All rights reserved.
//

import Foundation
import FBSDKLoginKit

// MARK: - FacebookClient (Convenient Resource Methods)

extension FacebookClient {
    
    // MARK: - Convenient Resource Methods
    func login(with readPermissions: [String], from viewController: UIViewController, andHandleCompletionWith completionHandler: @escaping (String?, NSError?) -> Void) {
        guard let currentAccessToken = FBSDKAccessToken.current() else {
            FBSDKLoginManager().logIn(withReadPermissions: readPermissions, from: viewController) { (result, error) in
                guard let result = result else {
                    if let error = error {
                        completionHandler(nil, error as NSError)
                    } else {
                        completionHandler(nil, nil)
                    }
                    
                    return
                }
                
                if result.isCancelled {
                    completionHandler(nil, nil)
                } else {
                    completionHandler(FBSDKAccessToken.current().tokenString, nil)
                }
            }
            
            return
        }
        
        completionHandler(currentAccessToken.tokenString, nil)
    }

    func obtainProfileInformation(with parameters: [String: Any], graphPath: String, version: String?, HTTPMethod: String, andHandleCompletionWith completionHandler: @escaping ([String: Any]?, NSError?) -> Void) {
        
        guard let tokenString = FBSDKAccessToken.current().tokenString else {
            print("No FBSDKAccessToken tokenString")
            return
        }
        
        guard let request = FBSDKGraphRequest(graphPath: graphPath, parameters: parameters, tokenString: tokenString, version: version, httpMethod: HTTPMethod) else {
            print("No FBSDKGraphRequest request")
            return
        }
        
        request.start() { (connection, result, error) in
            if let error = error {
                completionHandler(nil, error as NSError)
            } else if let result = result as? [String: Any] {
                completionHandler(result, nil)
            } else {
                completionHandler(nil, nil)
            }
        }
    }
}
