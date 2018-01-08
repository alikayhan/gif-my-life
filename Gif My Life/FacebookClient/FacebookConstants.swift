//
//  FacebookConstants.swift
//  Gif My Life
//
//  Created by Ali Kayhan on 24/06/2017.
//  Copyright © 2017 Ali Kayhan. All rights reserved.
//

// MARK: - FacebookClient (Constants)

extension FacebookClient {

    struct PermissionKeys {
        static let PublicProfile = "public_profile"
        static let Email = "email"
        static let UserBirthday = "user_birthday"
        static let UserFriends = "user_friends"
    }

    struct ErrorMessages {
        static let FacebookLoginError = "Facebook Login has encountered an error"
        static let UserCancelledFacebookLogin = "User has cancelled the Facebook Login"
        static let ObtainProfileInformationError = "Error while obtaining Facebook profile information"
    }

    struct GraphRequestValues {
        struct GraphPath {
            static let Me = "me"
        }
        
        struct HTTPMethod {
            static let Get = "GET"
        }
    }

    struct GraphRequestParametersKeys {
        static let Fields = "fields"
    }

    struct GraphRequestParameterValues {
        static let ID = "id"
        static let Email = "email"
        static let Name = "name"
        static let Picture = "picture"
        static let PictureTypeLarge = "picture.type(large)"
        static let Gender = "gender"
        static let Birthday = "birthday"
    }

    struct GraphRequestResultKeys {
        static let Name = "name"
        static let Picture = "picture"
        static let Data = "data"
        static let URL = "url"
        static let Email = "email"
        static let ID = "id"
    }
    
}
