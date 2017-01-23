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
    @IBOutlet weak var saveSecondButton: UIButton!
    @IBOutlet weak var leftSelectButton: UIButton!
    @IBOutlet weak var rightSelectButton: UIButton!
    @IBOutlet weak var open: UIBarButtonItem!
    
    var pickerLeft = UIImagePickerController()
    var pickerRight = UIImagePickerController()
    var following = [String]()
    var posts = [Post]()
    
    var chatController: ChatController?
    var buttonIndex = Int()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        pickerLeft.delegate = self
        pickerRight.delegate = self
        
        
        open.target = self.revealViewController()
        open.action = Selector("revealToggle:")
        
//        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any] ) {

        let image = info[UIImagePickerControllerEditedImage] as? UIImage
        
        if buttonIndex == 0 {
            self.leftImage.image = image
            leftSelectButton.isHidden = true
            saveButton.isHidden = false
            
        } else if buttonIndex == 1 {
            self.rightImage.image = image
            rightSelectButton.isHidden =  true
            saveSecondButton.isHidden = false
            
            
        }
        
        self.dismiss(animated: true, completion: nil)
    }
    

    @IBAction func leftSelectPressed(_ sender: Any) {
        buttonIndex = 0
        pickerLeft.allowsEditing = true
        pickerLeft.sourceType = .photoLibrary
        
        self.present(pickerLeft, animated: true, completion: nil)
    }

    @IBAction func rightSelectPressed(_ sender: Any) {
        buttonIndex = 1
        pickerRight.allowsEditing = true
        pickerRight.sourceType = .photoLibrary
        
        self.present(pickerRight, animated: true, completion: nil)
    }
    
    @IBAction func savePressed(_ sender: Any) {
        
        AppDelegate.instance().showActivityIndicator()
        
        let uid = FIRAuth.auth()?.currentUser!.uid
        let ref = FIRDatabase.database().reference()
        let storage = FIRStorage.storage().reference(forURL: "gs://programmeerproject.appspot.com")
        
        let key = ref.child("contracts").childByAutoId().key
        let imageRef = storage.child("contracts").child(uid!).child("\(key).jpg")
        
        let dataPhotoLeft = UIImageJPEGRepresentation(self.leftImage.image!, 0.6)
        
        let uploadTaskLeft = imageRef.put(dataPhotoLeft!, metadata: nil) {(metadata, error) in
            if error != nil {
                print(error!.localizedDescription)
                AppDelegate.instance().dismissActivityIndicator()
                return
            }
            
            imageRef.downloadURL(completion: { (url, error) in
                if let url = url {
                    let feed = ["userID": uid,
                                "pathToImage": url.absoluteString,
                                "author": FIRAuth.auth()!.currentUser!.displayName!,
                                "postID": key] as [String: Any]
                    
                    let postFeed = ["\(key)": feed]
                    
                    ref.child("contracts").updateChildValues(postFeed)
                    AppDelegate.instance().dismissActivityIndicator()
                    

                }
            })
        }
        
        uploadTaskLeft.resume()
        
    }
//    @IBAction func cancelPressed(_ sender: Any) {
//        self.dismiss(animated: true, completion: nil)
//    }
    @IBAction func readMessagePressed(_ sender: Any) {
//        let messagesController = MessagesController()

//        let navController = UINavigationController(rootViewController: messagesController)
//        present(navController, animated: true, completion: nil)
        
    }
    
    @IBAction func saveSecondPressed(_ sender: Any) {
        
//        AppDelegate.instance().showActivityIndicator()
        
        let uid = FIRAuth.auth()?.currentUser!.uid
        let ref = FIRDatabase.database().reference()
        let storage = FIRStorage.storage().reference(forURL: "gs://programmeerproject.appspot.com")
        
        let key = ref.child("contracts").childByAutoId().key
        let imageRef = storage.child("contracts").child(uid!).child("\(key).jpg")
        
        let dataPhotoRight = UIImageJPEGRepresentation(self.rightImage.image!, 0.6)
        
        let uploadTaskRight = imageRef.put(dataPhotoRight!, metadata: nil) {(metadata, error) in
            if error != nil {
                print(error!.localizedDescription)
//                AppDelegate.instance().dismissActivityIndicator()
                return
            }
            
            imageRef.downloadURL(completion: { (url, error) in
                if let url = url {
                    let feed = ["userID": uid,
                                "pathToImage": url.absoluteString,
                                "author": FIRAuth.auth()!.currentUser!.displayName!,
                                "postID": key] as [String: Any]
                    
                    
                    
                    let postFeedRight = ["\(key)": feed]
                    
                    ref.child("contracts").updateChildValues(postFeedRight)
//                    AppDelegate.instance().dismissActivityIndicator()
                    
                }
            })
        }
        uploadTaskRight.resume()
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
