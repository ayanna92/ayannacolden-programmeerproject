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

        fetch()
        
        open.target = self.revealViewController()
        open.action = Selector("revealToggle:")
        
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
    }
    
    // RETRIEVE PROFILE PHOTO USER, EDIT NEEDED!
    func fetchProfileImg() {
        let ref = FIRDatabase.database().reference()
        ref.child("users").queryOrderedByKey().observeSingleEvent(of: .value, with: { (snapshot) in
            
            let users = snapshot.value as! [String: AnyObject]
            
            DispatchQueue.main.async {
             
            for (_, value) in users {
                if let uid = value["uid"] as? String {
                    let userToShow = UserMessages()
                    if let imagePath = value["urlToImage"] as? String {
                        userToShow.urlToImage = imagePath
                        self.userMessages.append(userToShow)
                    }
                }
            }
            self.collectionView.reloadData()
            }
        })
        ref.removeAllObservers()
    }
    
    func fetch() {
        let ref = FIRDatabase.database().reference()
        
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
        return self.posts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = self.collectionView.dequeueReusableCell(withReuseIdentifier: "postCell", for: indexPath) as! PostCell
        cell.postImage.downloadImage(from: self.posts[indexPath.row].pathToImage!)
        cell.authorLabel.text = self.posts[indexPath.row].author
        cell.profileImage.downloadImage(from: self.userMessages[indexPath.row].urlToImage)
        
        return cell
    }


}
