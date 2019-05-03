//
//  SignUpViewController.swift
//  instagramCloneSwift
//
//  Created by MyMac on 2019-04-29.
//  Copyright © 2019 Apex. All rights reserved.
//

import UIKit
import FirebaseAuth
import Firebase
import UserNotifications


class SignUpViewController: UIViewController{

    override func viewDidLoad() {
        super.viewDidLoad()
        //handleTextField()
    }
    
    @IBOutlet weak var textID: UITextField!
    @IBOutlet weak var textMail: UITextField!
    @IBOutlet weak var textPassword: UITextField!
    
    
    
    
    @IBAction func ButtonSignUp(_ sender: UIButton) {
    
        checkingIdEmailPassword()
        
    }
    

    
    
    @IBAction func goBackToLogIn(_ sender: Any) {
           dismiss(animated: true, completion: nil)
    }
    
    
    
    func checkingIdEmailPassword() {
        
        guard  let idCheck = textID, idCheck.text!.count >= 6, let mailCheck = textMail, mailCheck.text!.count >= 6 ,
            let passwordCheck = textPassword, passwordCheck.text!.count >= 6
            
            else {
            
                let alert = UIAlertController(title:"Invalid Id or Password ", message: "ID, Email and Password Must be more than 6 charaters long", preferredStyle: UIAlertController.Style.alert)
                    alert.addAction(UIAlertAction(title: "Try Again", style: UIAlertAction.Style.default, handler: nil))
        
                    present(alert, animated: true, completion: nil)
            
            return
            }
        
        Auth.auth().createUser(withEmail: textMail.text!, password:textPassword.text!) { authResult, error in
            
            if error != nil {
                self.showAlert()
                print(error!.localizedDescription)
            }
            
            let database = Database.database().reference().child("users")
            print("user \(database.description())")
            
            database.childByAutoId().setValue(["username": self.textID.text!, "email": self.textMail.text!])
            self.performSegue(withIdentifier: "signUpSegue", sender: self)
        return
        }
        
    }
    
    
    func showAlert() {
        let alert = UIAlertController(title:"Invalid Id or Password ", message: "Invalid Email form", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Try Again", style: UIAlertAction.Style.default, handler: nil))
        
        present(alert, animated: true, completion: nil)
    }
    


    
    
  

}