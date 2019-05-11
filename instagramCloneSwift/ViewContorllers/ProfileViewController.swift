//
//  ProfileViewController.swift
//  instagramCloneSwift
//
//  Created by MyMac on 2019-04-29.
//  Copyright © 2019 Apex. All rights reserved.
//

import UIKit
import FirebaseStorage
import FirebaseAuth
import FirebaseDatabase
import SVProgressHUD

class ProfileViewController: UIViewController,UIImagePickerControllerDelegate, UINavigationControllerDelegate  {
    
    @IBOutlet weak var profileImageView: UIImageView!
    var selectedImage: UIImage?
    
    @IBOutlet weak var profilName: UITextField!
    var userName:String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        userName = Auth.auth().currentUser?.email
        profilName.text = userName
        
        profileImageView.layer.cornerRadius = 40
        profileImageView.clipsToBounds = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(ProfileViewController.handleSelectProfileImageView))
        profileImageView.addGestureRecognizer(tapGesture)
        profileImageView.isUserInteractionEnabled = true
        
    }
    
    @objc func handleSelectProfileImageView () {
        
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        present(imagePicker, animated: true, completion:nil)
        print("tapped")
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        print("did finish picking image")
        if let image = info[.originalImage] as? UIImage {
            selectedImage = image
            profileImageView.image = image
        }
        
        let user = Auth.auth().currentUser
        let selectedImageUrl = info[.imageURL]
        let storageRef = Storage.storage().reference(forURL: "gs://instagramcloneswift.appspot.com")
        let imageRef = storageRef.child("profile_photo").child(user!.email!)
        //let profileImageRef = storageRef.child("profile_Photo").child(user!.email!)
        
        imageRef.putFile(from: selectedImageUrl as! URL, metadata: nil) { metadata, error in
            if error != nil {
                
                return
            } else {
                
                //downloading Profile Image Url
                imageRef.downloadURL(completion: { (url, error) in
                    if error != nil {
                        print("Download URL fail")
                        return
                    }else {
                        let profilePhotoUrl  = url?.absoluteString
                        self.sendDataToDatabase(profilePhotoUrl: profilePhotoUrl!)
                    }
                })
                
                
                print("image uploaded")
                return
            }
            
        }
      //  print(info)
        dismiss(animated: true, completion: nil)
    }
    
    func sendDataToDatabase(profilePhotoUrl: String) {
        guard let currentUser = Auth.auth().currentUser else {
            return
        }
        
      //  let currentUserId = currentUser.uid as? String
        
        
        let ref = Database.database().reference()
        let postRef = ref.child("users")
        let newPostId = postRef.child(currentUser.uid)
        //let newPostRef = postRef.child(newPostId)
        
        
      //  let currentUserId = currentUser.uid
        
        newPostId.updateChildValues(["profileImageUrl":profilePhotoUrl]) { (error, DatabaseReference) in
            if error != nil {
                print("data upload fail")
                SVProgressHUD.showError(withStatus: error?.localizedDescription)
                return
            }
            print("data uploaded")
            SVProgressHUD.showSuccess(withStatus: "Success")
        }
        
        
    }
    
    
//    setValue(["profilePhotoUrl":profilePhotoUrl,
//
//    ]) { (error, ref) in
//    if error != nil {
//    print("data upload fail")
//    SVProgressHUD.showError(withStatus: error?.localizedDescription)
//    return
//    }
//    print("data uploaded")
//    SVProgressHUD.showSuccess(withStatus: "Success")
//
//    }
//
 
    
    
    
    
    @IBAction func buttonLogOut(_ sender: Any) {
        
        
        do {
            
            try  Auth.auth().signOut()
        } catch let logOutError {
            print(logOutError)
        }
       // print(Auth.auth().currentUser?.email)
        
        
        let storyboard =  UIStoryboard(name: "Main", bundle: nil)
        
        let logInVC = storyboard.instantiateViewController(withIdentifier: "LogInViewController")
        
        present(logInVC, animated: true, completion: nil)
        
    }
    
    
    
    
}

        
        
        
        


    
    

