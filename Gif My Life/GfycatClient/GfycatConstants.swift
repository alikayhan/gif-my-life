//
//  GfycatConstants.swift
//  Gif My Life
//
//  Created by Ali Kayhan on 03/06/2017.
//  Copyright © 2017 Ali Kayhan. All rights reserved.
//

// MARK: - GfycatClient (Constants)

extension GfycatClient {
    
    // MARK: - Gfycat URL Constants
    struct URLConstants {
        static let APIScheme = "https"
        static let APIHost = "api.gfycat.com"
        static let APIPath = "/v1"
        static let BaseURL = "https://api.gfycat.com/v1/"
    }
    
    // MARK: - Gfycat Parameter Keys
    struct ParameterKeys {
        static let GrantType = "grant_type"
        static let ClientID = "client_id"
        static let ClientSecret = "client_secret"
        static let TagName = "tagName"
        static let SearchText = "search_text"
        static let Count = "count"
        static let Cursor = "cursor"
    }
    
    // MARK: - Gfycat Parameter Values
    struct ParameterValues {
        static let GrantType = "client_credentials"
        static let ClientID = GfycatClient().gfycatClientID
        static let ClientSecret = GfycatClient().gfycatClientSecret
        static let Trending = "trending"
        static let AlgorithmicallyTrendingGifsCount = 100
        static let SearchGifsCount = 100
    }
    
    // MARK: - Gfycat Response Keys
    struct ResponseKeys {
        static let AccessToken = "access_token"
        static let Gfycats = "gfycats"
        
        static let ID = "gfyId"
        static let Name = "gfyName"
        static let Number = "gfyNumber"
        static let Width = "width"
        static let Height = "height"
        static let AverageColor = "avgColor"
        static let CreateDate = "createDate"
        static let NSFW = "nsfw"
        static let Tags = "tags"
        static let Title = "title"
        static let Description = "description"
        
        static let GifURL = "gifUrl"
        static let MobileURL = "mobileUrl"
        static let MobilePosterURL = "mobilePosterUrl"
        static let Max1MbURL = "max1mbGif"
        static let Max2MbURL = "max2mbGif"
        static let Max5MbURL = "max5mbGif"
    }
    
    // MARK: - Gfycat Response Values
    struct ResponseValues {
        // TODO: Determine parameter values (as expected) and add them as static constants here
    }
    
    // MARK: - Gfycat Header Fields
    struct HeaderFields {
        static let Authorization = "Authorization"
    }
    
    // MARK: - Gfycat Header Values
    struct HeaderValues {
        static let Bearer = "Bearer"
    }
    
    // MARK: - Gfycat Method Paths
    struct MethodPaths {
        static let GetToken = "oauth/token"
        static let GetTrendingGifs = "reactions/populated"
        static let GetAlgorithmicallyTrendingGifs = "gfycats/trending"
        static let GetAlgorithmicallyTrendingGifsForTag = "gfycats/trending"
        static let GetAlgorithmicallyTrendingTags = "tags/trending"
        static let GetAlgorithmicallyTrendingTagsPopulated = "tags/trending/populated"
        static let SearchGifs = "gfycats/search"
    }
}
