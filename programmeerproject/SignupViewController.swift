//
//  SignupViewController.swift
//  programmeerproject
//
//  Created by Ayanna Colden on 10/01/2017.
//  Copyright © 2017 Ayanna Colden. All rights reserved.
//

import UIKit
import Firebase

class SignupViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var confirmPwField: UITextField!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var selectButton: UIButton!
    
    let picker = UIImagePickerController()
    var userStorage: FIRStorageReference!
    var ref: FIRDatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)

        picker.delegate = self
        
        let storage = FIRStorage.storage().reference(forURL: "gs://programmeerproject.appspot.com")
        
        ref = FIRDatabase.database().reference()
        userStorage = storage.child("users")
    }
    
    
    @IBAction func selectImagePressed(_ sender: Any) {
        picker.allowsEditing = true
        picker.sourceType = .photoLibrary
        
        
        present(picker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let image = info[UIImagePickerControllerEditedImage] as? UIImage {
            self.imageView.image = image
            nextButton.isHidden = false
            selectButton.isHidden = true
        }
        self.dismiss(animated: true, completion: nil)
        
    }
    
    @IBAction func nextPressed(_ sender: Any) {
        
        if nameField.text == "" || emailField.text == "" || passwordField.text == "" || confirmPwField.text == "" {
            
            emptyError()
        }
        
        if (passwordField.text?.characters.count)! < 6 {
            incorrectError()
        }
        
        if passwordField.text == confirmPwField.text {
            FIRAuth.auth()?.createUser(withEmail: emailField.text!, password: passwordField.text!, completion: {
                (user, error) in
                
                if let error = error {
                    print(error.localizedDescription)
                }
                
                if let user = user {
                    
                    let changeRequest = FIRAuth.auth()!.currentUser!.profileChangeRequest()
                    changeRequest.displayName = self.nameField.text!
                    changeRequest.commitChanges(completion: nil)
                    
                    let imageRef = self.userStorage.child("\(user.uid).jpg")
                    
                    let data = UIImageJPEGRepresentation(self.imageView.image!, 0.5)
                    
                    let uploadTask = imageRef.put(data!, metadata: nil, completion: { (metadata, err) in
                        if err != nil {
                            print(err!.localizedDescription)
                        }
                        
                        imageRef.downloadURL(completion: { (url, er) in
                            if er != nil {
                                print(er!.localizedDescription)
                            }
                            
                            if let url = url {
                                let userInfo: [String: Any] = ["uid": user.uid,
                                                               "fullname": self.nameField.text!,
                                                               "urlToImage": url.absoluteString]
                                
                                // Assign user to firebase.
                                self.ref.child("users").child(user.uid).setValue(userInfo)
                                
                                let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "usersVC")
                                
                                self.present(vc, animated: true, completion: nil)
                            }
                        })
                    })
                    
                    uploadTask.resume()
                }
            })
            
        } else {
            incorrectError()
        }  
        
    }
    
    
    @IBAction func cancelPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func emptyError() {
        let errorAlert = UIAlertController(title: "Error", message: "Email and/or password not filled in.", preferredStyle: UIAlertControllerStyle.alert)
        errorAlert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.cancel, handler: nil))
        
        self.present(errorAlert, animated: true, completion: nil)
    }
    
    func incorrectError() {
        let errorAlert = UIAlertController(title: "Error", message: "Password and confirmed password do not match and/or password must be at least 6 characters", preferredStyle: UIAlertControllerStyle.alert)
        errorAlert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.cancel, handler: nil))
        
        self.present(errorAlert, animated: true, completion: nil)
    }
    
    // Keyboard functions:
    func keyboardWillShow(notification: NSNotification) {
        
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0{
                self.view.frame.origin.y -= keyboardSize.height
            }
        }
        
    }
    
    func keyboardWillHide(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y != 0{
                self.view.frame.origin.y += keyboardSize.height
            }
        }
    }


}
