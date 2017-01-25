//
//  LoginViewController.swift
//  programmeerproject
//
//  Created by Ayanna Colden on 10/01/2017.
//  Copyright © 2017 Ayanna Colden. All rights reserved.
//

import UIKit
import Firebase

class LoginViewController: UIViewController {

    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var pwField: UITextField!
    
    var messagesController: MessagesController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)

    }

    @IBAction func loginPressed(_ sender: Any) {
        
        if emailField.text == "" || pwField.text == "" {
            emptyError()
        }
        
        FIRAuth.auth()?.signIn(withEmail: emailField.text!, password: pwField.text!, completion: { (user, error) in
            if let error = error {
                self.incorrectError()
            }
            
            if let user = user {
                let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SWReveal")
                
                self.present(vc, animated: true, completion: nil)
            }
        })
    }

    func emptyError() {
        let errorAlert = UIAlertController(title: "Error", message: "Email and/or password not filled in.", preferredStyle: UIAlertControllerStyle.alert)
        errorAlert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.cancel, handler: nil))
        
        self.present(errorAlert, animated: true, completion: nil)
    }
    
    func incorrectError() {
        let errorAlert = UIAlertController(title: "Error", message: "Incorrect email and/or password.", preferredStyle: UIAlertControllerStyle.alert)
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

extension UIColor {
    
    convenience init(r: CGFloat, g: CGFloat, b: CGFloat) {
        self.init(red: r/255, green: g/255, blue: b/255, alpha: 1)
    }
    
}
