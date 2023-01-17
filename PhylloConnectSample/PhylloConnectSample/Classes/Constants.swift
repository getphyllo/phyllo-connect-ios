//
//  G.swift
//  phyllo_sdk
//
//  Created by Sanket on 10/08/21.
//

import UIKit
struct Constants {
    
    static var sdkToken = ""
    static var userId = ""
    static var clientDisplayName = "Sample App"
        
    // Generating Random String
    static func randomString(length: Int) -> String {
        let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        return String((0..<length).map{ _ in letters.randomElement()! })
    }
}
