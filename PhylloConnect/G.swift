//
//  G.swift
//  phyllo_sdk
//
//  Created by Sanket on 10/08/21.
//

import UIKit
struct G {

    
    //URLs for Network Requests
    static let privacyUrl = "https://getphyllo.com/privacy-policy.html"
    
    //vew controller of developer app
    static var developerVC = UIViewController()
    
    //custom-headers in Network Requests
    static let sdkTypeHeaderKey = "sdk-type"
    static let sdkVersionHeaderKey = "sdk-version"
    static let sdkType = "IOS"
    static let sdkVersion = "1.0"
    static let authHeader = "Basic <add your basic token here>"
    
    //custom-headers in Network Requests
    static let sdkTypeHeaderKey = "sdk-type"
    static let sdkVersionHeaderKey = "sdk-version"
    static let clientHeaderKey = "client_id"
    static let clientSecretHeaderKey = "client_secret"
    static let sdkType = "IOS"
    static let client_id = "<add your client id>"
    static let client_secret =  "<add your client secret>"
    static let sdkVersion = "1.0"
    
    //these parameters will be set from developer-app
    static var developerName = ""
    static var deepLinkURL = ""
    static var workPlatformId = ""
    static var sdkToken = ""
    
    
    //
    static var pollingInterval = 4.0
    
    static var userId = ""
    static let redirectURI = "https://etsy.ai"
    
    
    //Status mapping for Accounts List View
    static let statusDict : [String : Any] = [
        "CONNECTED" : ["color" : "dark-purple", "text" : "Connected", "image" : "icon_logout"],
        "EXPIRED" : ["color" : "warn", "text" : "Session Expired- Reconnect", "image" : "icon_sessionexpired"]
    ]
    
    // kerning values
    static let fourthKernValue: Float = 4.0
    static let doubleKernValue: Float = 2.0
    static let singleKernValue: Float = 1.0
    
    static var errorMsg = "There was an error in connecting to our servers. Please check your input and try again."
    
    // Generating Random String
    static func randomString(length: Int) -> String {
        let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        return String((0..<length).map{ _ in letters.randomElement()! })
    }
}
