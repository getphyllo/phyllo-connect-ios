//
//  G.swift
//  phyllo_sdk
//
//  Created by Sanket on 10/08/21.
//

import UIKit
struct G {

    
    //URLs for Network Requests
    static let privacyUrl = "https://argyle.com/security-and-compliance"
    
    //vew controller of developer app
    static var developerVC = UIViewController()
    
    //custom-headers in Network Requests
    static let sdkTypeHeaderKey = "sdk-type"
    static let sdkVersionHeaderKey = "sdk-version"
    static let clientHeaderKey = "client_id"
    static let clientSecretHeaderKey = "client_secret"
    static let sdkType = "IOS"
    static let client_id = "04eeded4-12c6-4f9c-80e3-8c53eb0973a1"
    static let client_secret =  "6fc7726c-702d-4fc3-87dd-5f2d6c3d7640"
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
