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

        fetchWithProfile()
        
        open.target = self.revealViewController()
        open.action = Selector("revealToggle:")
        
        self.collectionView.backgroundColor = UIColor.groupTableViewBackground
        
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
    }
    

    func fetchWithProfile() {
        
        let ref = FIRDatabase.database().reference()
        let uid = FIRAuth.auth()?.currentUser?.uid
        
        ref.child("users").queryOrderedByKey().observeSingleEvent(of: .value, with: { (snapshot) in
            
            let users = snapshot.value as! [String: AnyObject]
            
            for (_, value) in users {
                let id = value["uid"] as! String
 
                ref.child("message_images").observe(.childAdded, with: { (snap) in
                    
                    let key = snap.key
                        ref.child("message_images").child(key).observeSingleEvent(of: .value, with: { (snaps) in
                            
                            if let dictionary = snaps.value as? [String: AnyObject] {
                                
                                if let userID = dictionary["userID"] as? String, let toId = dictionary["toId"] as? String{
                                    print("toid: \(toId)")
                                    
                                    
                                    let userToShow = UserMessages()
                                    
                                    userToShow.uid = toId
 
                                    if toId == uid || userID == uid {
                                        if id == toId {

                                        DispatchQueue.main.async(execute: {
                                            
                                            let posst = Post()
                                            
                                            if let author = dictionary["author"] as? String, let pathToImage = dictionary["pathToImage"] as? String, let postID = dictionary["postID"] as? String, let imagePath = value["urlToImage"] as? String, let fullname = value["fullname"] as? String {
    
                                                
                                                posst.author = author
                                                posst.pathToImage = pathToImage
                                                posst.postID = postID
                                                posst.userID = userID
                                                posst.toId = toId
                                                userToShow.fullname = fullname
                                                userToShow.urlToImage = imagePath
                                                
                                                self.posts.append(posst)
                                                self.userMessages.append(userToShow)
                                            }
                                            
                                            self.collectionView.reloadData()
                                            
                                        })
                                    }
                                    }
                                }
                                
                            }
                        })
                })
                ref.removeAllObservers()

                
            }
        })
    
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
        cell.receiverLabel.text = self.userMessages[indexPath.row].fullname
        cell.profileImage.downloadImage(from: self.userMessages[indexPath.row].urlToImage)
        
        return cell
    }


}
