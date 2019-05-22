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
import SVProgressHUD


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
        
        //validating ID,Email and Password
        guard let idCheck = textID, idCheck.text!.count >= 6,
            let mailCheck = textMail, mailCheck.text!.count >= 6 ,
            let passwordCheck = textPassword, passwordCheck.text!.count >= 6
            
            else {
                let alert = UIAlertController(title:"Invalid Id or Password ", message: "ID, Email and Password Must be more than 6 charaters long", preferredStyle: UIAlertController.Style.alert)
                
                alert.addAction(UIAlertAction(title: "Try Again", style: UIAlertAction.Style.default, handler: nil))
                
                present(alert, animated: true, completion: nil)
                
                return
        }
        SVProgressHUD.show(withStatus: "Wait Please...")
       
        Auth.auth().createUser(withEmail: textMail.text!, password: textPassword.text!) { (user, error) in
            if error != nil {
                self.showAlert()
                print(error!.localizedDescription)
            }
            
            let uid = user?.uid
            let ref = Database.database().reference()
            let userReference = ref.child("users")
            let newUserReference = userReference.child(uid!)
            newUserReference.setValue(["username": self.textID.text!,
                                       "email": self.textMail.text!])
            
            SVProgressHUD.setMinimumDismissTimeInterval(1.0)
            SVProgressHUD.showSuccess(withStatus: "Sign Up Success")
            self.performSegue(withIdentifier: "signUpSegue", sender: self)
            // SVProgressHUD.dismiss()
            return
        }
        
    }
    
    
    func showAlert() {
        let alert = UIAlertController(title:"Invalid Id or Password ", message: "Invalid Email form", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Try Again", style: UIAlertAction.Style.default, handler: nil))
        
        present(alert, animated: true, completion: nil)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    
}
