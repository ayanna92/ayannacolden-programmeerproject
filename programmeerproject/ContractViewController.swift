//
//  ContractViewController.swift
//  programmeerproject
//
//  Created by Ayanna Colden on 18/01/2017.
//  Copyright © 2017 Ayanna Colden. All rights reserved.
//

import UIKit
import Firebase

class ContractViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    @IBOutlet weak var leftImage: UIImageView!
    @IBOutlet weak var rightImage: UIImageView!
    @IBOutlet weak var userOneLabel: UILabel!
    @IBOutlet weak var userTwoLabel: UILabel!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var leftSelectButton: UIButton!
    @IBOutlet weak var rightSelectButton: UIButton!
    
    var picker = UIImagePickerController()
    var following = [String]()
    var posts = [Post]()

    override func viewDidLoad() {
        super.viewDidLoad()

        picker.delegate = self
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let image = info[UIImagePickerControllerEditedImage] as? UIImage {
            self.leftImage.image = image
            leftSelectButton.isHidden = true
        }
        
        if let imageTwo = info[UIImagePickerControllerEditedImage] as? UIImage {
            self.rightImage.image = imageTwo
            rightSelectButton.isHidden =  true
            saveButton.isHidden = false
        }
        
        self.dismiss(animated: true, completion: nil)
    }

    @IBAction func leftSelectPressed(_ sender: Any) {
        // find way to select image from firebase conversation
    }

    @IBAction func rightSelectPressed(_ sender: Any) {
        // find way to select image from firebase conversation
    }
    
    @IBAction func savePressed(_ sender: Any) {
        
    }
    
    func fetchPosts(){
        
        let ref = FIRDatabase.database().reference()
        
        ref.child("users").queryOrderedByKey().observeSingleEvent(of: .value, with: { snapshot in
            
            let users = snapshot.value as! [String : AnyObject]
            
            for (_,value) in users {
                if let uid = value["uid"] as? String {
                    if uid == FIRAuth.auth()?.currentUser?.uid {
                        if let followingUsers = value["following"] as? [String : String]{
                            for (_,user) in followingUsers{
                                self.following.append(user)
                            }
                        }
                        self.following.append(FIRAuth.auth()!.currentUser!.uid)
                        
                        ref.child("message_images").queryOrderedByKey().observeSingleEvent(of: .value, with: { (snap) in
                            
                            
                            let postsSnap = snap.value as! [String : AnyObject]
                            
                            for (_,post) in postsSnap {
                                if let userID = post["userID"] as? String {
                                    for each in self.following {
                                        if each == userID {
                                            let posst = Post()
                                            if let author = post["author"] as? String, let pathToImage = post["pathToImage"] as? String, let postID = post["postID"] as? String {
                                                
                                                posst.author = author
                                                posst.pathToImage = pathToImage
                                                posst.postID = postID
                                                posst.userID = userID
                                                
                                                self.posts.append(posst)
                                            }
                                        }
                                    }
                                }
                            }
                        })
                    }
                }
            }
            
        })
        ref.removeAllObservers()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
