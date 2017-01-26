//
//  FeedViewController.swift
//  InstagramLike
//
//  Created by Vasil Nunev on 13/12/2016.
//  Copyright © 2016 Vasil Nunev. All rights reserved.
//

import UIKit
import Firebase

class FeedViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    
    @IBOutlet weak var open: UIBarButtonItem!

    @IBOutlet weak var collectionView: UICollectionView!
    
    
    var posts = [Post]()
    var userMessages = [UserMessages]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Feed"
        

//        fetch()
        fetchWithProfile()
        
        
        open.target = self.revealViewController()
        open.action = Selector("revealToggle:")
        
        self.collectionView.backgroundColor = UIColor.groupTableViewBackground
        
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
    }
    
    func fetchUsers() {
        
        let ref = FIRDatabase.database().reference()
        
        // Retrieve profile pictures.
        ref.child("users").queryOrderedByKey().observeSingleEvent(of: .value, with: { (snapshot) in
            
            let users = snapshot.value as! [String: AnyObject]
            
            
            DispatchQueue.main.async {
                
                for (_, value) in users {
                    if let id = value["uid"] as? String {
                        let userToShow = UserMessages()
                        if let imagePath = value["urlToImage"] as? String {
                            userToShow.urlToImage = imagePath
                            self.userMessages.append(userToShow)
                        }
                    }
                }
                
                self.collectionView.reloadData()
            }
            //ref.removeAllObservers()
        })
        
    }
    
    func fetchWithProfile() {
        
        let ref = FIRDatabase.database().reference()
        let uid = FIRAuth.auth()?.currentUser?.uid
        
        
        ref.child("users").queryOrderedByKey().observeSingleEvent(of: .value, with: { (snapshot) in
            
            let users = snapshot.value as! [String: AnyObject]
            for (_, value) in users {
                let id = value["uid"] as! String
                
                // Retrieve images sent in chats, for feed.
                ref.child("message_images").observe(.childAdded, with: { (snap) in
                    
                    let key = snap.key
                    
                    if let dict = snap.value as? [String: AnyObject] {
                        
                        let uid = FIRAuth.auth()?.currentUser?.uid as? String!
                        ref.child("message_images").child(key).observeSingleEvent(of: .value, with: { (snapshot) in
                            
                            if let dictionary = snapshot.value as? [String: AnyObject] {
                                
                                if let userID = dictionary["userID"] as? String, let toId = dictionary["toId"] as? String{
                                    
                                    
                                    
                                    if toId == uid || userID == uid {
                                        if id == userID {
                                        
                                        DispatchQueue.main.async(execute: {
                                            
                                            let posst = Post()
                                            let userToShow = UserMessages()
                                            if let author = dictionary["author"] as? String, let pathToImage = dictionary["pathToImage"] as? String, let postID = dictionary["postID"] as? String, let imagePath = value["urlToImage"] as? String {
                                                
                                                posst.author = author
                                                posst.pathToImage = pathToImage
                                                posst.postID = postID
                                                posst.userID = userID
                                                posst.toId = toId
                                                userToShow.urlToImage = imagePath
                                                
                                                print("image:\(posst.pathToImage)")
                                                
                                                self.posts.append(posst)
                                                self.userMessages.append(userToShow)
                                                
                                            }
                                            
                                            self.collectionView.reloadData()
                                            
                                        })
                                        //self.posts.removeAll()
                                        //self.userMessages.removeAll()
                                    }
                                    }
                                }
                                
                            }
                            
                        })
                    }
                })
                ref.removeAllObservers()

                
            }
        })
        
        
    
    
    }
    
    
    // ASK WHY IS NOT RELOADING PROPERLY
    func fetch() {
        let ref = FIRDatabase.database().reference()
      
        //self.userMessages.removeAll()
        self.posts.removeAll()
        
        ref.child("users").queryOrderedByKey().observeSingleEvent(of: .value, with: { (snapshot) in
            
            let users = snapshot.value as! [String: AnyObject]
            print("users: \(users)")
            DispatchQueue.main.async {
                
                for (_, value) in users {
                    if let id = value["uid"] as? String {
                            
                            
                            let userToShow = UserMessages()
                            if let imagePath = value["urlToImage"] as? String {
                                userToShow.urlToImage = imagePath
                                self.userMessages.append(userToShow)
                            }
                        }
                }
                
                self.collectionView.reloadData()
            }
            //ref.removeAllObservers()
        })
        
        
        // Retrieve images sent in chats, for feed.
        ref.child("message_images").observe(.childAdded, with: { (snap) in
            
            let key = snap.key
            
            if let dict = snap.value as? [String: AnyObject] {

                    let uid = FIRAuth.auth()?.currentUser?.uid as? String!
                    ref.child("message_images").child(key).observeSingleEvent(of: .value, with: { (snapshot) in
                        
                        if let dictionary = snapshot.value as? [String: AnyObject] {

                            if let userID = dictionary["userID"] as? String, let toId = dictionary["toId"] as? String{
                                
                               
                                
                                if toId == uid || userID == uid {
      
                                    DispatchQueue.main.async(execute: {
                                            
                                        let posst = Post()
                                        if let author = dictionary["author"] as? String, let pathToImage = dictionary["pathToImage"] as? String, let postID = dictionary["postID"] as? String {
                                            
                                            posst.author = author
                                            posst.pathToImage = pathToImage
                                            posst.postID = postID
                                            posst.userID = userID
                                            posst.toId = toId
                                            
                                            print("image:\(posst.pathToImage)")
                                            
                                            self.posts.append(posst)
                                            
                                        }
                                            
                                            self.collectionView.reloadData()
                                            
                                    })
                                        //self.posts.removeAll()
                                        //self.userMessages.removeAll()
                                }
                            }
                        
                        }
                        
                    })
            }
        })
        ref.removeAllObservers()
    }

    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print("count:\(self.posts.count)")
        print("user.count:\(self.userMessages.count)")
        return self.posts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        cell.backgroundColor = UIColor.clear
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = self.collectionView.dequeueReusableCell(withReuseIdentifier: "postCell", for: indexPath) as! PostCell
        cell.postImage.downloadImage(from: self.posts[indexPath.row].pathToImage!)
        cell.authorLabel.text = self.posts[indexPath.row].author
        cell.profileImage.downloadImage(from: self.userMessages[indexPath.row].urlToImage)
        
        return cell
    }


}
