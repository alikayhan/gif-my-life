//
//  NetworkManager.swift
//  Gif My Life
//
//  Created by Ali Kayhan on 9.12.2017.
//  Copyright © 2017 Ali Kayhan. All rights reserved.
//

import Foundation
import Alamofire

class NetworkManager: NSObject {
    
    // MARK: - Properties
    let reachabilityManager = Alamofire.NetworkReachabilityManager(host: "www.google.com")
    
    // Shared instance
    var shared: NetworkManager {
        get {
            struct Singleton {
                static var sharedInstance = NetworkManager()
            }
            return Singleton.sharedInstance
        }
    }
    
    // MARK: - Has Connectivity
    func hasConnectivity() -> Bool {
        return (reachabilityManager?.isReachable)!
    }
    
    // MARK: - Observe Network Reachability
    // FIXME: - The listener does not seem to be returning a status. Find out why
    func observeNetworkReachability() {
        reachabilityManager?.listener = { status in
            switch status {
            case .notReachable:
                print("Not reachable")
            case .unknown:
                print("Unknown")
            case .reachable(.ethernetOrWiFi):
                print("WiFi")
            case .reachable(.wwan):
                print("WWAN")
            }
        }
    }
}
    

