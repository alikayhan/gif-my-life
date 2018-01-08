//
//  GfycatRouter.swift
//  Gif My Life
//
//  Created by Ali Kayhan on 04/06/2017.
//  Copyright © 2017 Ali Kayhan. All rights reserved.
//

import Foundation
import Alamofire

enum GfycatRouter: URLRequestConvertible {
    
    // MARK: - HTTP Method Cases
    case getToken([String: Any])
    case getTrendingGifs([String: Any])
    case getAlgorithmicallyTrendingGifs([String: Any])
    case getAlgorithmicallyTrendingTags
    case getAlgorithmicallyTrendingTagsPopulated
    case searchGifs([String: Any])
    
    // MARK: - As URL Request
    func asURLRequest() throws -> URLRequest {
        var method: HTTPMethod {
            switch self {
            case .getToken:
                return .get
            case .getTrendingGifs:
                return .get
            case .getAlgorithmicallyTrendingGifs:
                return .get
            case .getAlgorithmicallyTrendingTags:
                return .get
            case .getAlgorithmicallyTrendingTagsPopulated:
                return .get
            case .searchGifs:
                return .get
            }
        }
        
        let params: ([String: Any]?) = {
            switch self {
            case .getToken(let params):
                return params
            case .getTrendingGifs(let params):
                return params
            case .getAlgorithmicallyTrendingGifs(let params):
                return params
            case .getAlgorithmicallyTrendingTags:
                return nil
            case .getAlgorithmicallyTrendingTagsPopulated:
                return nil
            case .searchGifs(let params):
                return params
            }
        }()
        
        let url: URL = {
            // Build up and return the URL for each endpoint
            let relativePath: String?
            
            switch self {
            case .getToken:
                relativePath = GfycatClient.MethodPaths.GetToken
            case .getTrendingGifs:
                relativePath = GfycatClient.MethodPaths.GetTrendingGifs
            case .getAlgorithmicallyTrendingGifs:
                relativePath = GfycatClient.MethodPaths.GetAlgorithmicallyTrendingGifs
            case .getAlgorithmicallyTrendingTags:
                relativePath = GfycatClient.MethodPaths.GetAlgorithmicallyTrendingTags
            case .getAlgorithmicallyTrendingTagsPopulated:
                relativePath = GfycatClient.MethodPaths.GetAlgorithmicallyTrendingTagsPopulated
            case .searchGifs:
                relativePath = GfycatClient.MethodPaths.SearchGifs
            }
            
            var url = URL(string: GfycatClient.URLConstants.BaseURL)!
            if let relativePath = relativePath {
                url = url.appendingPathComponent(relativePath)
            }
            
            return url
        }()
        
        // Create URL request
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = method.rawValue
        
        // Add token to authorization header if token has already been acquired
        if let token = GfycatClient().shared.token {
            urlRequest.setValue("\(token)", forHTTPHeaderField: GfycatClient.HeaderFields.Authorization)
        }
        
        // Determine a timeout interval for the request
        urlRequest.timeoutInterval = TimeInterval(10 * 1000)
        
        // Add parameters to URL request by URLEncoding
        let encoding = URLEncoding.default
        return try encoding.encode(urlRequest, with: params)
    }
}
