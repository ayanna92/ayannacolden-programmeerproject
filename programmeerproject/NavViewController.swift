//
//  NavViewController.swift
//  programmeerproject
//
//  Created by Ayanna Colden on 24/01/2017.
//  Copyright © 2017 Ayanna Colden. All rights reserved.
//

import UIKit

class NavViewController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let messageVC = MessagesController()
        self.viewControllers = [messageVC]
    }

}
