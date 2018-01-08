//
//  FirebaseServerValueConvenience.swift
//  Gif My Life
//
//  Created by Ali Kayhan on 27/06/2017.
//  Copyright © 2017 Ali Kayhan. All rights reserved.
//

import Foundation
import Firebase

// MARK: - FirebaseClient (Convenient Resource Methods - ServerValue)

extension FirebaseClient {
    
    // MARK: - Properties
    var serverTimestamp: [AnyHashable: Any] {
        get {
            return ServerValue.timestamp()
        }
    }
}
