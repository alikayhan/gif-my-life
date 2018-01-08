//
//  AppDelegate.swift
//  Gif My Life
//
//  Created by Ali Kayhan on 23/05/2017.
//  Copyright © 2017 Ali Kayhan. All rights reserved.
//

import UIKit
import Firebase
import FacebookCore
import FacebookLogin


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    let stack: CoreDataStack = CoreDataStack(modelName: "CoreDataModel")!
    
    // Set orientations to be allowed by the application
    var allowedOrientations = UIInterfaceOrientationMask.all

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Observe network reachability
        NetworkManager().shared.observeNetworkReachability()
        
        // Use Firebase library to configure APIs
        FirebaseApp.configure()
        
        // Enable Firebase persistence
        FirebaseClient().shared.setPersistenceEnabled(to: true)
        
        // Connect AppDelegate to Facebook SDK Application Delegate
        SDKApplicationDelegate.shared.application(application, didFinishLaunchingWithOptions: launchOptions)
        
        // Set initial user state
        UserManager().shared.setInitialUserState()
        
        // Read categories from Firebase
        CategoriesManager().shared.obtainCategories()
        
        // Let Core Data stack auto save in every 60 seconds
        stack.autoSave(60)

        return true
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        return SDKApplicationDelegate.shared.application(app, open: url, options: options)
    }

    func applicationWillResignActive(_ application: UIApplication) {
        do{
            try stack.saveContext()
        } catch {
            print(error.localizedDescription)
        }
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        do{
            try stack.saveContext()
        } catch {
            print(error.localizedDescription)
        }
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Call the 'activate' method to log an app event for use
        // in analytics and advertising reporting.
        AppEventsLogger.activate(application)
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        return allowedOrientations
    }
}
