    //
    //  SignUpViewController.swift
    //  instagramCloneSwift
    //
    //  Created by MyMac on 2019-04-29.
    //  Copyright © 2019 Apex. All rights reserved.
    //

    import UIKit

    import Firebase
    import UserNotifications
    import SVProgressHUD

    class SignUpViewController: UIViewController{
        
        override func viewDidLoad() {
            super.viewDidLoad()
        }
        
        @IBOutlet weak var textId: UITextField!
        @IBOutlet weak var textMail: UITextField!
        @IBOutlet weak var textPassword: UITextField!
        
        @IBAction func ButtonSignUp(_ sender: UIButton) {
            checkingIdEmailPassword()
            AuthService.signUp(email: textMail.text!, id: textId.text!, password: textPassword.text!, onSuccess: {
                 self.performSegue(withIdentifier: "signUpSegue", sender: self)
            }) {
                self.showAlert()
            }
        }
        
        @IBAction func goBackToLogIn(_ sender: Any) {
            dismiss(animated: true, completion: nil)
        }
        
        func checkingIdEmailPassword() {
            
            //validating ID,Email and Password
            guard let idCheck = textId, idCheck.text!.count >= 6,
                let mailCheck = textMail, mailCheck.text!.count >= 6 ,
                let passwordCheck = textPassword, passwordCheck.text!.count >= 6
                
                else {
                    let alert = UIAlertController(title:"Invalid Id or Password ", message: "ID, Email and Password Must be more than 6 charaters long", preferredStyle: UIAlertController.Style.alert)
                    
                    alert.addAction(UIAlertAction(title: "Try Again", style: UIAlertAction.Style.default, handler: nil))
                    
                    present(alert, animated: true, completion: nil)
                    
                    return
            }
            SVProgressHUD.show(withStatus: "Wait Please...")
           
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
