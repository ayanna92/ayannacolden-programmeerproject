//
//  UserMessages.swift
//  programmeerproject
//
//  Created by Ayanna Colden on 17/01/2017.
//  Copyright © 2017 Ayanna Colden. All rights reserved.
//

import UIKit

class UserMessages: NSObject {
    var uid: String?
    var fullname: String?
    var email: String?
    var urlToImage: String?
    var following: [String: AnyObject]!
    var followers: [String: AnyObject]!
}

