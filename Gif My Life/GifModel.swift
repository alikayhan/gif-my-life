//
//  GifModel.swift
//  Gif My Life
//
//  Created by Ali Kayhan on 04/06/2017.
//  Copyright © 2017 Ali Kayhan. All rights reserved.
//

import Foundation
import UIKit

// MARK: - Gif Model

// This struct is used to create Gif objects after GETting gifs from Gfycat
struct Gif {
    
    // MARK: - Properties
    let id: String!
    let name: String!
    let number: String!
    let width: Double!
    let height: Double!
    let avgColor: String!
    let createDate: Int64!
    let nsfw: String!
    let tags: [String]!
    let title: String!
    let description: String!
    
    let gifURL: String!
    let mobileURL: String!
    let mobilePosterURL: String!
    let max1MbURL: String!
    let max2MbURL: String!
    let max5MbURL: String!
    
    let dataPack: [String: Any]!
    
    // MARK: - Initializers
    
    // Construct a Gif object from a dictionary
    init(from dictionary: [String: Any]) {
        id = dictionary[GfycatClient.ResponseKeys.ID] as? String
        name = dictionary[GfycatClient.ResponseKeys.Name] as? String
        number = dictionary[GfycatClient.ResponseKeys.Number] as? String
        width = dictionary[GfycatClient.ResponseKeys.Width] as? Double
        height = dictionary[GfycatClient.ResponseKeys.Height] as? Double
        avgColor = dictionary[GfycatClient.ResponseKeys.AverageColor] as? String
        createDate = dictionary[GfycatClient.ResponseKeys.CreateDate] as? Int64
        nsfw = dictionary[GfycatClient.ResponseKeys.NSFW] as? String
        
        // Some gifs have tags property as nil rather than an empty arrray.
        // This causes problem with Firebase Database actions. Therefore, an empty array
        // has been assigned to tags property if tags is nil.
        if let tagArray = dictionary[GfycatClient.ResponseKeys.Tags] as? [String] {
            tags = tagArray
        } else {
            tags = []
        }
        title = dictionary[GfycatClient.ResponseKeys.Title] as? String
        description = dictionary[GfycatClient.ResponseKeys.Description] as? String
        
        gifURL = dictionary[GfycatClient.ResponseKeys.GifURL] as? String
        mobileURL = dictionary[GfycatClient.ResponseKeys.MobileURL] as? String
        mobilePosterURL = dictionary[GfycatClient.ResponseKeys.MobilePosterURL] as? String
        max1MbURL = dictionary[GfycatClient.ResponseKeys.Max1MbURL] as? String
        max2MbURL = dictionary[GfycatClient.ResponseKeys.Max2MbURL] as? String
        max5MbURL = dictionary[GfycatClient.ResponseKeys.Max5MbURL] as? String
        
        dataPack = [GfycatClient.ResponseKeys.ID: id,
                    GfycatClient.ResponseKeys.Name: name,
                    GfycatClient.ResponseKeys.Number: number,
                    GfycatClient.ResponseKeys.Width: width,
                    GfycatClient.ResponseKeys.Height: height,
                    GfycatClient.ResponseKeys.AverageColor: avgColor,
                    GfycatClient.ResponseKeys.CreateDate: createDate,
                    GfycatClient.ResponseKeys.NSFW: nsfw,
                    GfycatClient.ResponseKeys.Tags: tags,
                    GfycatClient.ResponseKeys.Title: title,
                    GfycatClient.ResponseKeys.Description: description,
                    GfycatClient.ResponseKeys.GifURL: gifURL,
                    GfycatClient.ResponseKeys.MobileURL: mobileURL,
                    GfycatClient.ResponseKeys.MobilePosterURL: mobilePosterURL,
                    GfycatClient.ResponseKeys.Max1MbURL : max1MbURL,
                    GfycatClient.ResponseKeys.Max2MbURL: max2MbURL,
                    GfycatClient.ResponseKeys.Max5MbURL: max5MbURL]
    }
    
    // Construct a Gif array from results
    static func gifArray(from results: [[String: Any]]) -> [Gif] {
        var gifArray = [Gif]()
        
        // Iterate through array of dictionaries where each dictionary represents a gif
        for result in results {
            gifArray.append(Gif(from: result))
        }
        
        return gifArray
    }
}
