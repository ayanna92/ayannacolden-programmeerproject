//
//  BackTableVC.swift
//  programmeerproject
//
//  Created by Ayanna Colden on 21/01/2017.
//  Copyright © 2017 Ayanna Colden. All rights reserved.
//

import Foundation

class BackTableVC: UITableViewController {
    
    var tableArray = [String]()
    
    override func viewDidLoad() {
        
        tableArray = ["Users", "New Messages", "Messages", "Log Out"]
        
    }
    
//    override func viewWillAppear(_ animated: Bool) {
//        let image = UIImage(named: "images-2")
//        let transparentImage = image?.image(alpha: 0.5)
//        self.view.backgroundColor = UIColor(patternImage: transparentImage!)
//        
//    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: tableArray[indexPath.row], for: indexPath) as UITableViewCell
        
        return cell
    }
    


    
    
}
