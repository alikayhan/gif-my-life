//
//  FirebaseClient.swift
//  Gif My Life
//
//  Created by Ali Kayhan on 24/06/2017.
//  Copyright © 2017 Ali Kayhan. All rights reserved.
//

import Foundation
import Firebase

class FirebaseClient: NSObject {
    
    // MARK: - Properties
    var refHandle: DatabaseHandle!

    var shared: FirebaseClient {
        get {
            struct Singleton {
                static var sharedInstance = FirebaseClient()
            }
            return Singleton.sharedInstance
        }
    }
    
    // MARK: - Initializers
    override init() {
        super.init()
    }
}
