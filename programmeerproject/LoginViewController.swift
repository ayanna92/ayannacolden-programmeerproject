//
//  LoginViewController.swift
//  programmeerproject
//
//  Created by Ayanna Colden on 10/01/2017.
//  Copyright © 2017 Ayanna Colden. All rights reserved.
//

import UIKit
import Firebase

// Source: https://www.youtube.com/watch?v=AsSZulMc7sk

class LoginViewController: UIViewController {

    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var pwField: UITextField!
    
    var messagesController: MessagesController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.isHidden = true
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)

    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        let image = UIImage(named: "images-2")
        let transparentImage = image?.image(alpha: 0.5)
        self.view.backgroundColor = UIColor(patternImage: transparentImage!)
        
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

}


