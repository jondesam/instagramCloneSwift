//
//  LogInViewController.swift
//  instagramCloneSwift
//
//  Created by MyMac on 2019-04-29.
//  Copyright © 2019 Apex. All rights reserved.
//

import UIKit
import FirebaseAuth


class LogInViewController: UIViewController {

    
    @IBOutlet weak var textEmail: UITextField!
    
    @IBOutlet weak var TextPassword: UITextField!
    
    
    @IBAction func buttonLogIn(_ sender: UIButton) {
        
        Auth.auth().signIn(withEmail: textEmail.text!, password: TextPassword.text!) { (user, error) in
            
            if error != nil {
                print(error!)
            } else {
                print("Log in successful!")
                
               // SVProgressHUD.dismiss()
                
                //self.performSegue(withIdentifier: "goToChat", sender: self)
                
            }
            
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

   

}
