//
//  GfycatConvenience.swift
//  Gif My Life
//
//  Created by Ali Kayhan on 03/06/2017.
//  Copyright © 2017 Ali Kayhan. All rights reserved.
//

import Foundation
import Alamofire

// MARK: GfycatClient (Convenient Resource Methods)

extension GfycatClient {
    
    // MARK: - Get Token
    func getToken(andHandleCompletionWith completionHandler: @escaping (Any?, Error?) -> Void) {
        
        let parameters = [GfycatClient.ParameterKeys.ClientID: GfycatClient.ParameterValues.ClientID!,
                      GfycatClient.ParameterKeys.ClientSecret: GfycatClient.ParameterValues.ClientSecret!,
                      GfycatClient.ParameterKeys.GrantType: GfycatClient.ParameterValues.GrantType]
        
        Alamofire.request(GfycatRouter.getToken(parameters))
        .validate()
        .responseJSON { (response) in
            
            guard response.result.error == nil else {
                // Handle the error returned in response
                print(response.result.error!)
                completionHandler(nil, response.result.error)
                return
            }
            
            if let responseJSON = response.result.value as? [String: Any] {
                if let token = responseJSON[GfycatClient.ResponseKeys.AccessToken] as? String {
                    completionHandler(token, nil)
                } else {
                    print("Error parsing getToken responseJSON. Response key not found.")
                    completionHandler(nil, nil)
                }
            }
        }
    }
    
    // MARK: - Get Trending Gifs
    func getTrendingGifs(andHandleCompletionWith completionHandler: @escaping (Any?, Error?) -> Void) {
        
        let parameters = [GfycatClient.ParameterKeys.TagName: GfycatClient.ParameterValues.Trending] as [String : Any]
        
        Alamofire.request(GfycatRouter.getTrendingGifs(parameters))
        .validate()
        .responseJSON { (response) in
            guard response.result.error == nil else {
                // Handle the error returned in response
                print(response.result.error!)
                completionHandler(nil, response.result.error)
                return
            }
            
            if let responseJSON = response.result.value as? [String: Any] {
                if let results = responseJSON[GfycatClient.ResponseKeys.Gfycats] as? [[String: Any]] {
                    let gifs = Gif.gifArray(from: results)
                    completionHandler(gifs, nil)
                } else {
                    print("Error parsing getTrendingGifs responseJSON. Response key not found.")
                    completionHandler(nil, nil)
                }
            }
        }
    }
    
    // MARK: - Get Algorithmically Trending Gifs
    func getAlgorithmicallyTrending(_ count: Int = GfycatClient.ParameterValues.AlgorithmicallyTrendingGifsCount, gifsFor tagName: String = "", withCursor cursor: String = "", andHandleCompletionWith completionHandler: @escaping (Any?, Error?) -> Void) {
        
        let parameters = [GfycatClient.ParameterKeys.TagName: tagName,
                          GfycatClient.ParameterKeys.Count: count,
                          GfycatClient.ParameterKeys.Cursor: cursor] as [String : Any]
        
        Alamofire.request(GfycatRouter.getAlgorithmicallyTrendingGifs(parameters))
        .validate()
        .responseJSON { (response) in
            guard response.result.error == nil else {
                // Handle the error returned in response
                print(response.result.error!)
                completionHandler(nil, response.result.error)
                return
            }
            
            if let responseJSON = response.result.value as? [String: Any] {
                if let results = responseJSON[GfycatClient.ResponseKeys.Gfycats] as? [[String: Any]] {
                    let gifs = Gif.gifArray(from: results)
                    completionHandler(gifs, nil)
                } else {
                    print("Error parsing getTrendingGifs responseJSON. Response key not found.")
                    completionHandler(nil, nil)
                }
            }
        }
    }
    
    // MARK: - Search
    func search(_ count: Int = GfycatClient.ParameterValues.SearchGifsCount, gifsFor searchText: String, withCursor cursor: String = "", andHandleCompletionWith completionHandler: @escaping (Any?, Error?) -> Void) {
        
        let parameters = [GfycatClient.ParameterKeys.SearchText: searchText,
                          GfycatClient.ParameterKeys.Count: count,
                          GfycatClient.ParameterKeys.Cursor: cursor] as [String: Any]
        
        Alamofire.request(GfycatRouter.searchGifs(parameters))
        .validate()
        .responseJSON { (response) in
            guard response.result.error == nil else {
                // Handle the error returned in response
                print(response.result.error!)
                completionHandler(nil, response.result.error)
                return
            }
            
            if let responseJSON = response.result.value as? [String: Any] {
                if let results = responseJSON[GfycatClient.ResponseKeys.Gfycats] as? [[String: Any]] {
                    let gifs = Gif.gifArray(from: results)
                    completionHandler(gifs, nil)
                } else {
                    print("Error parsing searchGifs responseJSON. Response key not found.")
                    completionHandler(nil, nil)
                }
            }
        }
    }
    
    // MARK: - Download Image
    func downloadImage(with url: String, andHandleCompletionWith completionHandler: @escaping (Any?) -> Void) {
        
        guard let url = URL(string: url) else {
            completionHandler(nil)
            return
        }
        
        // Download image in a background thread
        DispatchQueue.global(qos: .background).async {
            do {
                let imageData = try Data(contentsOf: url)
                completionHandler(imageData)
            } catch {
                print(error.localizedDescription)
                completionHandler(nil)
            }
        }
    }
}
