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
        
        tableArray = ["Users", "Make Contract", "Contracts", "New Messages", "Messages", "Log Out"]
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: tableArray[indexPath.row], for: indexPath) as UITableViewCell
        
        return cell
    }
    
//    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        print(indexPath.row)
//        if indexPath.row == 4 {
//            
//            AppDelegate.instance().switchRootViewController(rootViewController: MessagesController(), animated: true, completion: nil)
//            
//
////            self.navigationController?.pushViewController(MessagesController(), animated: true)
//            
////            let navController = UINavigationController(rootViewController: MessagesController())
////                    present(navController, animated: true, completion: nil)
//        }
//    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if (segue.identifier == "messageSegue") {
//            let navigationVC = segue.destination as? UINavigationController
//            let destinationVC = navigationVC?.viewControllers.first as! MessagesController
//            present(destinationVC, animated:true, completion: nil)
//            
//        }
        if segue.identifier == "messageSegue" {
            
            let messageVC = MessagesController()
            revealViewController().setFront(messageVC, animated: true)
            
        }
        
        if segue.identifier == "newMessageSegue" {
            let newMessageVC = NewMessagesController()
            revealViewController().setFront(newMessageVC, animated: true)
        }
    }
    

//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        
//        MessagesController().navigationController
//        
//    }
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == "makeContract" {
//            let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "contractVc")
//            self.present(vc, animated: true, completion: nil)
//        }
//    }


    
    
}
