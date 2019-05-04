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
        
        checkingEmailPassword()
        
    }
    
    func  checkingEmailPassword() {
        
        guard  let mailCheck = textEmail, mailCheck.text!.count >= 6 ,
            let passwordCheck = textPassword, passwordCheck.text!.count >= 6
            
            else {
                showAlert()
                
                return
        }
        SVProgressHUD.show(withStatus: "Wait Please...")
        Auth.auth().signIn(withEmail: textEmail.text!, password: textPassword.text!) { (user, error) in
            
            if error != nil {
                self.showAlert()
                print(error!.localizedDescription)
            } else {
                print("Log in successful!")
                SVProgressHUD.setMinimumDismissTimeInterval(1.0)
                 SVProgressHUD.showSuccess(withStatus: "Sign Up Success")
                
                self.performSegue(withIdentifier: "logInSegue", sender: self)
                
                
            }
            
        }
        
    }
    
    func showAlert() {
        let alert = UIAlertController(title:"Invalid ID or Password ", message: "Please check out ID or Passwrod", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Try Again", style: UIAlertAction.Style.default, handler: nil))
        
        present(alert, animated: true, completion: nil)
    }
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //handleTextField()
        
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if Auth.auth().currentUser != nil {
            self.performSegue(withIdentifier: "logInSegue", sender: self)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
       view.endEditing(true)
    }
    
    
}
