    //
    //  LogInViewController.swift
    //  instagramCloneSwift
    //
    //  Created by MyMac on 2019-04-29.
    //  Copyright © 2019 Apex. All rights reserved.
    //

    import UIKit
    import FirebaseAuth
    import SVProgressHUD

    class LogInViewController: UIViewController {
        
        @IBOutlet weak var textEmail: UITextField!
        @IBOutlet weak var textPassword: UITextField!
        
        @IBAction func buttonLogIn(_ sender: UIButton) {
            checkingEmailPassword(email: textEmail.text!, password: textPassword.text!)
            
            AuthService.signIn(email: textEmail.text!, password: textPassword.text!, onSuccess: {
                 self.performSegue(withIdentifier: "logInSegue", sender: self)
            }) {
                self.showAlert()
            }
        }

        
        override func viewDidLoad() {
            super.viewDidLoad()
            if Auth.auth().currentUser != nil {
                self.performSegue(withIdentifier: "logInSegue", sender: self)
            }
        }
        
        override func viewDidAppear(_ animated: Bool) {
            super.viewDidAppear(animated)
           
            if Auth.auth().currentUser != nil {
                self.performSegue(withIdentifier: "logInSegue", sender: self)
            }
        }
        
        func  checkingEmailPassword(email:String, password:String) {
            
            if email.count <= 6,password.count <= 6 {
                showAlert()
                return
            }
            SVProgressHUD.show(withStatus: "Wait Please...")
        }

        
        func showAlert() {
            let alert = UIAlertController(title:"Invalid ID or Password ", message: "Please check out ID or Passwrod", preferredStyle: UIAlertController.Style.alert)
            
            alert.addAction(UIAlertAction(title: "Try Again", style: UIAlertAction.Style.default, handler: nil))
            
                present(alert, animated: true, completion: nil)
        }
        
        override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
           view.endEditing(true)
        }
        
    }
