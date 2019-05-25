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

class ProfileViewController: UIViewController,UIImagePickerControllerDelegate, UINavigationControllerDelegate, UICollectionViewDataSource  {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCell" , for: indexPath)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let headerViewCell = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "HeaderProfileCollectionReusableView", for:indexPath) as! HeaderProfileCollectionReusableView
        headerViewCell.backgroundColor = UIColor.red
        headerViewCell.updateView()
        return headerViewCell
    }
    
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var profileImageViewOri: UIImageView!
    var selectedImage: UIImage?
    
    @IBOutlet weak var profileName: UITextField!
    @IBOutlet weak var profilNameOri: UITextField!
    var userName:String?
    
    //database setup
    let user = Auth.auth().currentUser
    let storageRef = Storage.storage().reference(forURL: "gs://instagramcloneswift.appspot.com")
    lazy var profileImageRef = storageRef.child("profile_photo").child(user!.email!)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.dataSource = self
        userName = Auth.auth().currentUser?.email
     //   profileName.text = userName
        
      //  profileImageView.layer.cornerRadius = 40
       // profileImageView.clipsToBounds = true
        
        //Allow user to touch imageView as button
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(ProfileViewController.handleSelectProfileImageView))
      //  profileImageView.addGestureRecognizer(tapGesture)
      //  profileImageView.isUserInteractionEnabled = true
        
    }
    
    @objc func handleSelectProfileImageView () {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        present(imagePicker, animated: true, completion:nil)
        print("tapped")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        profileImageRef.downloadURL(completion: { (url, error) in
            if error != nil {
                print("Download URL fail")
                return
            }else {
              //  self.profileImageView.sd_setImage(with: url)
            }
        })
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        print("did finish picking image")
        if let image = info[.originalImage] as? UIImage {
            // selectedImage = image
            profileImageView.image = image
        }
        
        let selectedImageUrl = info[.imageURL]
        
        profileImageRef.putFile(from: selectedImageUrl as! URL, metadata: nil) { metadata, error in
            if error != nil {
                return
            } else {
                //downloading Profile Image Url
                self.profileImageRef.downloadURL(completion: { (url, error) in
                    if error != nil {
                        print("Download URL fail")
                        return
                    }else {
                        let profilePhotoUrl  = url?.absoluteString
                        
                        self.sendDataToDatabase(profilePhotoUrl: profilePhotoUrl!)
                        
                        self.profileImageView.sd_setImage(with: url)
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
        let ref = Database.database().reference()
        let postRef = ref.child("users")
        let newPostId = postRef.child(currentUser.uid)
        
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
    
    @IBAction func buttonLogOut(_ sender: Any) {
        
        do {
            try  Auth.auth().signOut()
        } catch let logOutError {
            print(logOutError)
        }
        //print(Auth.auth().currentUser?.email)
        
        let storyboard =  UIStoryboard(name: "Main", bundle: nil)
        
        let logInVC = storyboard.instantiateViewController(withIdentifier: "LogInViewController")
        
        present(logInVC, animated: true, completion: nil)
        
    }
}










