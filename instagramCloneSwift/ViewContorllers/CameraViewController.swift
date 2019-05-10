//
//  CameraViewController.swift
//  instagramCloneSwift
//
//  Created by MyMac on 2019-04-29.
//  Copyright © 2019 Apex. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseStorage
import FirebaseDatabase
import SVProgressHUD


class CameraViewController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate {

    @IBOutlet weak var photoToShare: UIImageView!
    
    @IBOutlet weak var photoDescription: UITextView!
    
    @IBOutlet weak var buttonShareOutlet: UIButton!
    var selectedImage: UIImage?
    var selectedImageUrl :Any? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.handleSelectProfileImageView))
        photoToShare.addGestureRecognizer(tapGesture)
        photoToShare.isUserInteractionEnabled = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        photoDescription.text = ""
        handlePost()
    }
    
     // MARK: - sharing button on and off
    func handlePost() {
        if selectedImage != nil {
            buttonShareOutlet.isEnabled = true
            buttonShareOutlet.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1)
        } else {
            buttonShareOutlet.isEnabled = false
            buttonShareOutlet.backgroundColor = .lightGray
        }
    }
    
    //MARK: - Image picker set up
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
            photoToShare.image = image
            selectedImageUrl = info[.imageURL]
        }
            dismiss(animated: true, completion: nil)
    }
    
    
    //MARK: - Sharing Button
    @IBAction func buttonShare(_ sender: Any) {
        SVProgressHUD.show(withStatus: "Wait Please...")
        
        if let imageData = selectedImage!.jpegData(compressionQuality: 0.1){
            
            let uuid =  UUID().uuidString
            let user = Auth.auth().currentUser
            
            let storageRef = Storage.storage().reference(forURL: "gs://instagramcloneswift.appspot.com")
            let imageRef = storageRef.child("Sharing_Photo").child(user!.email!).child(uuid)
            
            imageRef.putData(imageData, metadata: nil) { (metadata, error) in
                if error != nil {
                    print(error!)
                    SVProgressHUD.showError(withStatus: "Upload Failed")
                    return
                } else {
                    SVProgressHUD.setMinimumDismissTimeInterval(1.0)
                    
                    imageRef.downloadURL(completion: { (url, error) in
                        if error != nil {
                            print("Download URL fail")
                            return
                        }else {
                            let photoUrl = url?.absoluteString
                            self.sendDataToDatabase(photoUrl: photoUrl!)
                        }
                    })
                    SVProgressHUD.showSuccess(withStatus: "Upload Success")
                    print("image uploaded")
                    return
                }
                
            
            
            
        //    putFile(from: imageData, metadata: nil) { metadata, error in
               
            }
            photoToShare.image = UIImage(named: "placeholder.png")
            tabBarController?.selectedIndex = 0
            selectedImage = nil
            
        }
            
        
        
     
    }
    
    func sendDataToDatabase(photoUrl: String) {
        let ref = Database.database().reference()
        let postRef = ref.child("Posts")
        let newPostId = postRef.childByAutoId().key
        let newPostRef = postRef.child(newPostId)
        
        newPostRef.setValue(["photoUrl":photoUrl,"description":photoDescription.text!,
                             "user":Auth.auth().currentUser?.email]) { (error, ref) in
            if error != nil {
                print("data upload fail")
             SVProgressHUD.showError(withStatus: error?.localizedDescription)
                return
            }
            print("data uploaded")
            SVProgressHUD.showSuccess(withStatus: "Success")
            self.photoDescription.text = ""
        }
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
}


