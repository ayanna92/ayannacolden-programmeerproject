//
//  Message.swift
//  programmeerproject
//
//  Created by Ayanna Colden on 12/01/2017.
//  Copyright © 2017 Ayanna Colden. All rights reserved.
//

import Foundation
import UIKit

class Message: NSObject {
    
    var fromId: String?
    var text: String?
    var timestamp: NSNumber?
    var toId: String?
    
    func chatPartnerId() -> String? {
        return fromId == FIRAuth.auth()?.currentUser?.uid ? toId : fromId
    }
    
}
