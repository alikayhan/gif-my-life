//
//  UIConstants.swift
//  Gif My Life
//
//  Created by Ali Kayhan on 06/06/2017.
//  Copyright © 2017 Ali Kayhan. All rights reserved.
//

import Foundation
import UIKit
import SwifterSwift

struct UIConstants {
    
    struct Color {
        static let GMLPurple = UIColor.init(hexString: "#0A5591")
        static let GMLPink = UIColor.init(hexString: "#FA3791")
        static let GMLLightPurple = UIColor.init(hexString: "#C1CEFE")
    }
    
    struct Title {
        struct ViewController {
            static let UserProfile = "You"
            static let SavedGifs = "Saved"
            static let LikedGifs = "Liked"
            static let SignIn = "Sign In"
            static let SignUp = "Sign Up"
            static let ForgotPassword = "Forgot Password"
        }
        
        struct TableViewHeader {
            static let SignIn = "Come In"
            static let SignUp = "No Account?"
            static let SavedLiked = "Saved&Liked"
            static let Categories = "Wanna See..."
            static let SignedIn = "Welcome"
            static let SignOut = "Leaving?"
        }
        
        struct SignInUp {
            static let SignIn = "Sign In"
            static let SignUp = "Sign Up"
            static let ForgotPassword = "Forgot password?"
            static let ResetPassword = "Reset Password"
        }
        
        struct AlertAction {
            static let OK = "OK"
        }
    }
    
    struct Label {
        static let Loading = "We are preparing the best gifs for you..."
        
        struct TableViewRow {
            static let SignInWithEmail = "Sign in with e-mail"
            static let SignInWithFacebook = "Sign in with Facebook"
            static let SignUpWithEmail = "Sign up with e-mail"
            static let SignUpWithFacebook = "Sign up with Facebook"
            static let Liked = "See what you've liked"
            static let Saved = "See what you've saved"
            static let Username = "Username"
            static let Email = "Email"
            static let SignOut = "Sign out"
        }
        
        struct EmptyState {
            static let LikedGifs = "You haven't liked any gifs yet. Start liking and they will appear here!"
            static let SavedGifs = "You haven't saved any gifs yet. Start saving and they will appear here!"
        }
        
        struct ForgotPassword {
            static let EnterEmail = "Enter the e-mail address registered on your account"
        }
    }
    
    struct Placeholder {
        struct SignInUp {
            static let EmailTextField = "E-mail"
            static let PasswordTextField = "Password (at least 6 chars)"
            static let UsernameTextField = "Username"
        }
    }
    
    struct Error {
        static let EmailPasswordEmpty = "E-mail/Password Empty"
        static let EmailEmpty = "E-mail Empty"
        static let InsufficientInformation = "Insufficient Information"
        
        static let InvalidEmail = "Invalid E-mail"
        static let LoginFailed = "Invalid E-mail/Password"
        static let ResetPasswordFailed = "Reset Password Failed"
        static let WeakPassword = "Weak Password"
        static let InvalidUsername = "Invalid Username"
        static let UserNotFound = "User Not Found"
        static let SignInSignUpFailed = "SignIn/SignUp Failed"
        static let SignOutFailed = "SignOut Failed"
        
        static let FacebookSignUpFailed = "Facebook Sign Up Failed"
        static let TryFacebookSignIn = "Facebook account on this device is already linked with an account. Try signing in with Facebook"
        
        static let NetworkProblem = "Network Problem"
        static let NoInternetConnection = "No Internet Connection"
        static let DownloadFailed = "Download Failed"
        
        static let EmailAlreadyInUse = "E-mail Already In Use"
        static let UsernameAlreadyInUse = "Username Already In Use"
        static let UnidentifiedError = "Unidentified Error"
    }
    
    struct Confirmation {
        static let ResetPasswordLinkSent = "Reset Password Link Sent"
        static let SignOutSuccessful = "Sign Out Successful"
    }
    
    struct Size {
        struct TableView {
            static let HeaderHeight: CGFloat = 40
        }
        
        struct GifCollectionView {
            static let SpaceBetweenItems: CGFloat = 3.0
            static let ItemsInARow = 2
        }
        
        struct Button {
            static let CornerRadius: CGFloat = 4.0
        }
        
        struct TextField {
            static let CornerRadius: CGFloat = 4.0
        }
    }
}
