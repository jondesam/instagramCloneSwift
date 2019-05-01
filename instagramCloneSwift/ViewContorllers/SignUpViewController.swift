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


class SignUpViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    @IBOutlet weak var textID: UITextField!
    
    @IBOutlet weak var textMail: UITextField!
    
    @IBOutlet weak var textPassword: UITextField!
    
    
    @IBAction func goBackToSignUp(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func ButtonSignUp(_ sender: UIButton) {
       
        
        
        Auth.auth().createUser(withEmail: textMail.text!, password:textPassword.text!) { authResult, error in
            if error != nil {
                print(error!.localizedDescription)
            }
            
            let database = Database.database().reference().child("users")
            print("user \(database.description())")
            database.childByAutoId().setValue(["username": self.textID.text!, "email": self.textMail.text!])
        
            
        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
