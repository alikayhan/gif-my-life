//
//  GifManager.swift
//  Gif My Life
//
//  Created by Ali Kayhan on 04/06/2017.
//  Copyright © 2017 Ali Kayhan. All rights reserved.
//

import Foundation
import UIKit
import CoreData
import Firebase

class GifManager: NSObject {
    
    // MARK: - Properties    
    var gifArray = [Gif]()
    var stack: CoreDataStack!
    
    // Shared instance
    var shared: GifManager {
        get {
            struct Singleton {
                static var sharedInstance = GifManager()
            }
            
            return Singleton.sharedInstance
        }
    }
    
    var downloadedGifs: [DownloadedGif] {
        get {
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            stack = appDelegate.stack
            
            var gifs = [DownloadedGif]()
            
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "DownloadedGif")
            do {
                if let results = try? stack.context.fetch(fetchRequest) as! [DownloadedGif] {
                    gifs = results
                }
            }
            
            return gifs
        }
    }
    
    var downloadedGifsIDs: [String] {
        get {
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            stack = appDelegate.stack
            
            var ids = [String]()
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "DownloadedGif")
            do {
                if let downloadedGifs = try? stack.context.fetch(fetchRequest) as! [DownloadedGif] {
                    for gif in downloadedGifs {
                        ids.append(gif.id!)
                    }
                } else {
                    print("Fetch request for getDownloadedGifsIDs method has failed")
                }
            }
            
            return ids
        }
    }
    
    // MARK: - Methods
    func createGifObject(from downloadedGif: DownloadedGif) -> Gif {
        
        let dataPack: [String: Any] = [GfycatClient.ResponseKeys.ID: downloadedGif.id ?? "",
                                       GfycatClient.ResponseKeys.Name: downloadedGif.name ?? "",
                                       GfycatClient.ResponseKeys.Number: downloadedGif.number ?? "",
                                       GfycatClient.ResponseKeys.Width: downloadedGif.width,
                                       GfycatClient.ResponseKeys.Height: downloadedGif.height,
                                       GfycatClient.ResponseKeys.CreateDate: downloadedGif.createDate,
                                       GfycatClient.ResponseKeys.AverageColor: downloadedGif.avgColor ?? "",
                                       GfycatClient.ResponseKeys.NSFW: downloadedGif.nsfw ?? "",
                                       GfycatClient.ResponseKeys.Tags: downloadedGif.tags ?? [],
                                       GfycatClient.ResponseKeys.Title: downloadedGif.title ?? "",
                                       GfycatClient.ResponseKeys.Description: downloadedGif.desc ?? "",
                                       GfycatClient.ResponseKeys.GifURL: downloadedGif.gifURL ?? "",
                                       GfycatClient.ResponseKeys.MobileURL: downloadedGif.mobileURL ?? "",
                                       GfycatClient.ResponseKeys.MobilePosterURL: downloadedGif.mobilePosterURL ?? "",
                                       GfycatClient.ResponseKeys.Max1MbURL : downloadedGif.max1MbURL ?? "",
                                       GfycatClient.ResponseKeys.Max2MbURL: downloadedGif.max2MbURL ?? "",
                                       GfycatClient.ResponseKeys.Max5MbURL: downloadedGif.max5MbURL ?? ""]
        
        return Gif(from: dataPack)
    }
    
    
    func createGifObject(from dataSnapshot: DataSnapshot) -> Gif? {
        
        guard let item = dataSnapshot.value as? [String: Any] else {
            return nil
        }
        
        let dataPack: [String: Any] = [GfycatClient.ResponseKeys.AverageColor: item[GfycatClient.ResponseKeys.AverageColor] as! String,
                                          GfycatClient.ResponseKeys.CreateDate: item[GfycatClient.ResponseKeys.CreateDate] as! Int64,
                                          GfycatClient.ResponseKeys.Description: item[GfycatClient.ResponseKeys.Description] as! String,
                                          GfycatClient.ResponseKeys.ID: item[GfycatClient.ResponseKeys.ID] as! String,
                                          GfycatClient.ResponseKeys.Name: item[GfycatClient.ResponseKeys.Name] as! String,
                                          GfycatClient.ResponseKeys.Number: item[GfycatClient.ResponseKeys.Number] as! String,
                                          GfycatClient.ResponseKeys.GifURL: item[GfycatClient.ResponseKeys.GifURL] as! String,
                                          GfycatClient.ResponseKeys.Height: item[GfycatClient.ResponseKeys.Height] as! Double,
                                          GfycatClient.ResponseKeys.Max1MbURL: item[GfycatClient.ResponseKeys.Max1MbURL] as! String,
                                          GfycatClient.ResponseKeys.Max2MbURL: item[GfycatClient.ResponseKeys.Max2MbURL] as! String,
                                          GfycatClient.ResponseKeys.Max5MbURL: item[GfycatClient.ResponseKeys.Max5MbURL] as! String,
                                          GfycatClient.ResponseKeys.MobileURL: item[GfycatClient.ResponseKeys.MobileURL] as! String,
                                          GfycatClient.ResponseKeys.MobilePosterURL: item[GfycatClient.ResponseKeys.MobilePosterURL] as! String,
                                          GfycatClient.ResponseKeys.NSFW: item[GfycatClient.ResponseKeys.NSFW] as! String,
                                          GfycatClient.ResponseKeys.Tags: item[GfycatClient.ResponseKeys.Tags] as? [String] ?? [],
                                          GfycatClient.ResponseKeys.Title: item[GfycatClient.ResponseKeys.Title] as! String,
                                          GfycatClient.ResponseKeys.Width: item[GfycatClient.ResponseKeys.Width] as! Double
        ]

        return Gif(from: dataPack)
    }
}
