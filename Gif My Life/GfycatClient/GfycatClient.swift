//
//  GfycatClient.swift
//  Gif My Life
//
//  Created by Ali Kayhan on 03/06/2017.
//  Copyright © 2017 Ali Kayhan. All rights reserved.
//

import Foundation

class GfycatClient: NSObject {
    
    // MARK: - Properties
    var gfycatClientID: String!
    var gfycatClientSecret: String!
    
    // Gfycat Authentication Token
    var token: String!
    
    // Shared instance
    var shared: GfycatClient {
        get {
            struct Singleton {
                static var sharedInstance = GfycatClient()
            }
            return Singleton.sharedInstance
        }
    }
    
    // MARK: - Initializers
    override init() {
        super.init()
        
        if let path = Bundle.main.path(forResource: "Secrets", ofType: "plist") {
            if let secrets = NSDictionary(contentsOfFile: path) {
                gfycatClientID = secrets["gfycatClientID"] as! String
                gfycatClientSecret = secrets["gfycatClientSecret"] as! String
            }
        }
    }
}
