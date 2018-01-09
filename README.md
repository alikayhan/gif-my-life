<a href="https://ibb.co/dZCHNR"><img src="https://preview.ibb.co/jyHj2R/gif_my_life_logo_1024.jpg" alt="gif_my_life_logo_1024" border="0" width ="120" height ="120"></a>

# Gif My Life

Gif My Life is an iOS app which displays gifs from different categories. Choose a topic and then enjoy, like, share and download fun gifs.

## Features

 * Display gifs
 * Easily swipe for a new gif or a previous one
 * Download a gif to device
 * Like a gif
 * Share a gif, even in Whatsapp
 * Create an account so never lose what you liked
 
## Screenshots

<a href="https://ibb.co/fJeye6" target="_blank"><img src="https://preview.ibb.co/kBrYCR/1.jpg" alt="1" border="0" width ="150" height ="267"></a>
<a href="https://ibb.co/eiWpmm" target="_blank"><img src="https://preview.ibb.co/k2b0sR/2.jpg" alt="2" border="0" width ="150" height ="267"></a>
<a href="https://ibb.co/g8ZWz6" target="_blank"><img src="https://preview.ibb.co/fbzye6/3.jpg" alt="3" border="0" width ="150" height ="267"></a>
<a href="https://ibb.co/kggN6m" target="_blank"><img src="https://preview.ibb.co/mDHvRm/4.jpg" alt="4" border="0" width ="150" height ="267"></a>
<a href="https://ibb.co/fxjLsR" target="_blank"><img src="https://preview.ibb.co/hc3rz6/5.jpg" alt="5" border="0" width ="150" height ="267"></a>

## Compatibility
 
 * iPhone
 * Minimum iOS version: 10.0
 
## Requirements

* Xcode 9
* Swift 4

## How To Make It Work

* Clone the GitHub repository. You do not need to install the Cocoapod dependencies as they are already inluded in the project repository.
```
$ git clone https://github.com/alikayhan/gif-my-life.git
$ cd gif-my-life
```

* Gif My Life uses an API provided by [Gfycat](https://gfycat.com/). First, sign up [here](https://developers.gfycat.com/signup) to get your own Gfycat API credentials.
* Gif My Life uses [Firebase](https://firebase.google.com/) as the backend service. Go to [Firebase Console](https://console.firebase.google.com/) and create an iOS project for Gif My Life. Remember that Firebase sign-in methods should include Email/Password, Facebook and Anonymous.
* For Facebook sign-in, you can get the App ID and an App Secret for your app on the [Facebook for Developers](https://developers.facebook.com/) site.
* Insert your Gfycat API credentials to ``Secrets-Empty.plist`` file in [Gif My Life](https://github.com/alikayhan/gif-my-life/tree/master/Gif%20My%20Life) folder.
* Rename ``Secrets-Empty.plist`` file to ``Secrets.plist`` file.
* Add ``GoogleService-Info.plist`` file to [Gif My Life](https://github.com/alikayhan/gif-my-life/tree/master/Gif%20My%20Life) folder.
* Open .xcworkspace file
```
$ open open Gif\ My\ Life.xcworkspace
```

## License

This project is licensed under the terms of the MIT License.

## Author

Ali Kayhan, http://alikayhan.com

## Udacity

Please note that this project is the author's final project for [Udacity](https://www.udacity.com/)'s [iOS Developer Nanodegree](https://www.udacity.com/course/ios-developer-nanodegree--nd003) program.
