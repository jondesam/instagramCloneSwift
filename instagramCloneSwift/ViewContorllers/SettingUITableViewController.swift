//
//  SettingUITableViewController.swift
//  instagramCloneSwift
//
//  Created by MyMac on 2019-06-24.
//  Copyright © 2019 Apex. All rights reserved.
//

import UIKit
import SVProgressHUD

protocol SettingUITableViewControllerDelegate {
    func updateUserInfoRealTime()
}

class SettingUITableViewController: UITableViewController {

    
    var delegateOfSettingUITableViewController: SettingUITableViewControllerDelegate?
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var usernameTextField: UITextField!
    
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var bio: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

       navigationItem.title = "Edit Profile"
        fectchCurrentUser()
    }

    func fectchCurrentUser(){
        Api.UserAPI.observeCurrentUser { (user) in
            
            if let profileURL = URL(string: user.profileImageUrl ?? "placeholderImg.jpeg")  {
                self.profileImageView.sd_setImage(with: profileURL)
            }
            self.usernameTextField.text = user.username
            self.emailLabel.text = user.email
            self.bio.text = user.bio
            
        }
    }
   
    @IBAction func saveButton(_ sender: Any) {
        print("saveBTN")
        //profileImage check
        
        if let profileImage = self.profileImageView.image, let imageData = profileImage.jpegData(compressionQuality: 0.1){
            
            SVProgressHUD.show(withStatus: "Waiting...")
            
        
            AuthService.updateUserInfo(username: usernameTextField.text!, imageData: imageData, bio: bio.text!, onSuccess: {
                
                SVProgressHUD.showSuccess(withStatus: "Success")
                self.delegateOfSettingUITableViewController?.updateUserInfoRealTime()
                
            }) { (errorMessage) in
            
                SVProgressHUD.showError(withStatus: errorMessage)
            
            }
            
            
            
        }
      
    }
    
    @IBAction func logOutButton(_ sender: Any) {
        
        AuthService.logOut(onSuccess: {
            let storyboard =  UIStoryboard(name: "Main", bundle: nil)
            
            let logInVC = storyboard.instantiateViewController(withIdentifier: "LogInViewController")
            
            self.present(logInVC, animated: true, completion: nil)
            
        }) { (logOutError) in
            SVProgressHUD.showError(withStatus: logOutError)
        }
    
    }
    
    @IBAction func changeProfileButton(_ sender: Any) {
    
       let pickerController = UIImagePickerController()
        pickerController.delegate = self
    present(pickerController, animated: true, completion: nil)
    
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
        print("touchesBegan")
    }
    
}

extension SettingUITableViewController: UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let image = info[.originalImage] as? UIImage {
            
            profileImageView.image = image
        }
        
          dismiss(animated: true, completion: nil)
    }
}
