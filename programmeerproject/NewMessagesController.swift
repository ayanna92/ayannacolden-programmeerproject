//
//  newMessagesController.swift
//  programmeerproject
//
//  Created by Ayanna Colden on 17/01/2017.
//  Copyright © 2017 Ayanna Colden. All rights reserved.
//

import UIKit
import Firebase

class NewMessagesController: UITableViewController {
    
    let cellId = "cellId"
    
    var users = [UserMessages]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(handleCancel))
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "menu_icon") , style: .plain, target: self.revealViewController(), action: Selector("revealToggle:"))
        
//        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        
        followingUsers()
        tableView.register(UserMessageCell.self, forCellReuseIdentifier: cellId)
        
        
    }
    
    func followingUsers() {
        let ref = FIRDatabase.database().reference()
        let uid = FIRAuth.auth()!.currentUser!.uid
        
        ref.child("users").child(uid).child("following").queryOrderedByKey().observeSingleEvent(of: .value, with: { snapshot in
            if let following = snapshot.value as? [String: AnyObject] {
                for(_, value) in following {
                    let fid = value as! String
                    
                    let userToShow = UserMessages()
                    userToShow.uid = fid
                    ref.child("users").queryOrderedByKey().observeSingleEvent(of: .value, with: { snapshot in
                        
                        let user = snapshot.value as! [String : AnyObject]
                        self.users.removeAll()
                        if fid == value as? String {
                            for (_, value) in user {
                                let uid = value["uid"] as? String
                                if fid == uid {

                                    DispatchQueue.main.async {
                                        
                                        if let fullName = value["fullname"] as? String, let imagePath = value["urlToImage"] as? String {
                                            userToShow.fullname = fullName
                                            userToShow.urlToImage = imagePath
                                            self.users.append(userToShow)
                                            
                                        }
                                        self.tableView.reloadData()
                                    }
                                    
                                }
                            }
                        }
                    })
                }
            }
        })
    }

    
    func fetchUser() {
        FIRDatabase.database().reference().child("users").observe(.childAdded, with: { (snapshot) in
            
            if let dictionary = snapshot.value as? [String: AnyObject] {
                let user = UserMessages()
                user.uid = snapshot.key
                
                //if you use this setter, your app will crash if your class properties don't exactly match up with the firebase dictionary keys
                user.setValuesForKeys(dictionary)
                self.users.append(user)
                
                //this will crash because of background thread, so lets use dispatch_async to fix
                DispatchQueue.main.async(execute: {
                    self.tableView.reloadData()
                })
                
                //                user.name = dictionary["name"]
            }
            
        }, withCancel: nil)
    }
    
    func handleCancel() {
        dismiss(animated: true, completion: nil)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! UserMessageCell
        
        let user = users[(indexPath as NSIndexPath).row]
        cell.textLabel?.text = user.fullname
        cell.detailTextLabel?.text = user.email
        
        if let profileImageUrl = user.urlToImage {
            cell.profileImageView.loadImageUsingCacheWithUrlString(profileImageUrl)
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 72
    }
    
    var messagesController: MessagesController?
    
    func showChatControllerForUser(_ user: UserMessages) {
        let chatLogController = ChatController(collectionViewLayout: UICollectionViewFlowLayout())
        chatLogController.user = user
//        present(chatLogController, animated: true, completion: nil)
        navigationController?.popToViewController(chatLogController, animated: true)
//        navigationController?.pushViewController(chatLogController, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        dismiss(animated: true) {
            print("Dismiss completed")
            let user = self.users[(indexPath as NSIndexPath).row]
            print(user.fullname)
//            self.showChatControllerForUser(user)
            self.messagesController?.showChatControllerForUser(user)
        }
    }
    
}









