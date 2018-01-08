//
//  FacebookClient.swift
//  Gif My Life
//
//  Created by Ali Kayhan on 24/06/2017.
//  Copyright © 2017 Ali Kayhan. All rights reserved.
//

import Foundation

class FacebookClient: NSObject {
    
    // MARK: - Properties
    var shared: FacebookClient {
        get {
            struct Singleton {
                static var sharedInstance = FacebookClient()
            }
            return Singleton.sharedInstance
        }
    }
    
    // MARK: - Initializers
    override init() {
        super.init()
    }
}
