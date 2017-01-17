//
//  AppState.swift
//  programmeerproject
//
//  Created by Ayanna Colden on 16/01/2017.
//  Copyright © 2017 Ayanna Colden. All rights reserved.
//

import Foundation

class AppState: NSObject {
    
    static let sharedInstance = AppState()
    
    var signedIn = false
    var displayName: String?
    var photoURL: URL?
}
