//
//  UsersViewController.swift
//  programmeerproject
//
//  Created by Ayanna Colden on 10/01/2017.
//  Copyright © 2017 Ayanna Colden. All rights reserved.
//

import UIKit
import Firebase

class UsersViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    
    @IBOutlet weak var tableview: UITableView!

    var user = [User]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        retrieveUsers()
    }
    
    
    func retrieveUsers() {
        let ref = FIRDatabase.database().reference()
        
        ref.child("users").queryOrderedByKey().observeSingleEvent(of: .value, with: { snapshot in
            
            let users = snapshot.value as! [String : AnyObject]
            self.user.removeAll()
            for (_, value) in users {
                if let uid = value["uid"] as? String {
                    if uid != FIRAuth.auth()!.currentUser!.uid {
                        let userToShow = User()
                        if let fullName = value["full name"] as? String, let imagePath = value["urlToImage"] as? String {
                            userToShow.fullName = fullName
                            userToShow.imagePath = imagePath
                            userToShow.userID = uid
                            self.user.append(userToShow)
                        }
                    }
                }
            }
            self.tableview.reloadData()
        })
        ref.removeAllObservers()
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableview.dequeueReusableCell(withIdentifier: "userCell", for: indexPath) as! UserCell
        
        cell.nameLabel.text = self.user[indexPath.row].fullName
        cell.userID = self.user[indexPath.row].userID
        cell.userImage.downloadImage(from: self.user[indexPath.row].imagePath!)
        checkFollowing(indexPath: indexPath)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return user.count ?? 0
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let uid = FIRAuth.auth()!.currentUser!.uid
        let ref = FIRDatabase.database().reference()
        let key = ref.child("users").childByAutoId().key
        
        var isFollower = false
        
        ref.child("users").child(uid).child("following").queryOrderedByKey().observeSingleEvent(of: .value, with: { snapshot in
            
            if let following = snapshot.value as? [String : AnyObject] {
                for (ke, value) in following {
                    if value as! String == self.user[indexPath.row].userID {
                        isFollower = true
                        
                        ref.child("users").child(uid).child("following/\(ke)").removeValue()
                        ref.child("users").child(self.user[indexPath.row].userID).child("followers/\(ke)").removeValue()
                        
                        self.tableview.cellForRow(at: indexPath)?.accessoryType = .none
                    }
                }
            }
            if !isFollower {
                let following = ["following/\(key)" : self.user[indexPath.row].userID]
                let followers = ["followers/\(key)" : uid]
                
                ref.child("users").child(uid).updateChildValues(following)
                ref.child("users").child(self.user[indexPath.row].userID).updateChildValues(followers)
                
                self.tableview.cellForRow(at: indexPath)?.accessoryType = .checkmark
            }
        })
        ref.removeAllObservers()
        
    }
    
    
    func checkFollowing(indexPath: IndexPath) {
        let uid = FIRAuth.auth()!.currentUser!.uid
        let ref = FIRDatabase.database().reference()
        
        ref.child("users").child(uid).child("following").queryOrderedByKey().observeSingleEvent(of: .value, with: { snapshot in
            
            if let following = snapshot.value as? [String : AnyObject] {
                for (_, value) in following {
                    if value as! String == self.user[indexPath.row].userID {
                        self.tableview.cellForRow(at: indexPath)?.accessoryType = .checkmark
                    }
                }
            }
        })
        ref.removeAllObservers()
        
    }
    
    @IBAction func logOutPressed(_ sender: Any) {
    }
    
}


extension UIImageView {
    
    func downloadImage(from imgURL: String!) {
        let url = URLRequest(url: URL(string: imgURL)!)
        
        let task = URLSession.shared.dataTask(with: url) {
            (data, response, error) in
            
            if error != nil {
                print(error!)
                return
            }
            
            DispatchQueue.main.async {
                self.image = UIImage(data: data!)
            }
            
        }
        
        task.resume()
    }
}
    
//    var user = [User]()
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        
//        self.tableView.delegate = self
//        self.tableView.dataSource = self
//        
//        retrieveUsers()
//
//
//    }
//    
//    func retrieveUsers() {
//        let ref = FIRDatabase().reference()
//        
//        ref.child("users").queryOrderedByKey().observeSingleEvent(of: .value, with: { snapshot in
//            let users = snapshot.value as! [String: AnyObject]
//            self.user.removeAll()
//            for (_, value) in users {
//                if let uid = value["uid"] as? String {
//                    if uid != FIRAuth.auth()!.currentUser!.uid {
//                        let userToShow = User()
//                        if let fullName = value["full name"] as? String, let imagePath = value["urlToImage"] as? String {
//                            userToShow.fullName = fullName
//                            userToShow.imagePath = imagePath
//                            userToShow.userID = uid
//                            self.user.append(userToShow)
//                        }
//                    }
//                }
//            }
//            
//            self.tableView.reloadData()
//        })
//        
//        ref.removeAllObservers()
//    }
//    
//    func numberOfSections(in tableView: UITableView) -> Int {
//        return 1
//    }
//    
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "userCell", for: indexPath) as! UserCell
//        
//        cell.nameLabel.text = self.user[indexPath.row].fullName
//        cell.userID = self.user[indexPath.row].userID
//        cell.userImage.downloadImage(from: self.user[indexPath.row].imagePath!)
//        checkFollowing(indexPath: indexPath)
//        
//        return cell
//    }
//    
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        print(user.count)
//        return user.count ?? 0
//    }
//    
//    // kopie
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        
//        let uid = FIRAuth.auth()!.currentUser!.uid
//        let ref = FIRDatabase.database().reference()
//        let key = ref.child("users").childByAutoId().key
//        
//        var isFollower = false
//        
//        ref.child("users").child(uid).child("following").queryOrderedByKey().observeSingleEvent(of: .value, with: { snapshot in
//            
//            if let following = snapshot.value as? [String : AnyObject] {
//                for (ke, value) in following {
//                    if value as! String == self.user[indexPath.row].userID {
//                        isFollower = true
//                        
//                        ref.child("users").child(uid).child("following/\(ke)").removeValue()
//                        ref.child("users").child(self.user[indexPath.row].userID).child("followers/\(ke)").removeValue()
//                        
//                        self.tableView.cellForRow(at: indexPath)?.accessoryType = .none
//                    }
//                }
//            }
//            if !isFollower {
//                let following = ["following/\(key)" : self.user[indexPath.row].userID]
//                let followers = ["followers/\(key)" : uid]
//                
//                ref.child("users").child(uid).updateChildValues(following)
//                ref.child("users").child(self.user[indexPath.row].userID).updateChildValues(followers)
//                
//                self.tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
//            }
//        })
//        ref.removeAllObservers()
//        
//    }
//    
//    
//    func checkFollowing(indexPath: IndexPath) {
//        let uid = FIRAuth.auth()!.currentUser!.uid
//        let ref = FIRDatabase.database().reference()
//        
//        ref.child("users").child(uid).child("following").queryOrderedByKey().observeSingleEvent(of: .value, with: { snapshot in
//            
//            if let following = snapshot.value as? [String : AnyObject] {
//                for (_, value) in following {
//                    if value as! String == self.user[indexPath.row].userID {
//                        self.tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
//                    }
//                }
//            }
//        })
//        ref.removeAllObservers()
//        
//    }
//
//    @IBAction func logoutPressed(_ sender: Any) {
//    }
//    
//    
//    override func didReceiveMemoryWarning() {
//        super.didReceiveMemoryWarning()
//        // Dispose of any resources that can be recreated.
//    }
//    
//
//    /*
//    // MARK: - Navigation
//
//    // In a storyboard-based application, you will often want to do a little preparation before navigation
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        // Get the new view controller using segue.destinationViewController.
//        // Pass the selected object to the new view controller.
//    }
//    */
//
//}
//
//// function that any imageview can access
//extension UIImageView {
//    
//    func downloadImage(from imgURL: String!) {
//        let url = URLRequest(url: URL(string: imgURL)!)
//        
//        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
//            
//            if error != nil {
//                print(error!)
//                return
//            }
//            
//            DispatchQueue.main.async {
//                self.image = UIImage(data: data!)
//            }
//        }
//        
//        task.resume()
//    }
//    
//    
//    
//    
//}
