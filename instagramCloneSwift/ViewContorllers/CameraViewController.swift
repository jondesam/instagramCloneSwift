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
        
        let uuid =  UUID().uuidString
        let user = Auth.auth().currentUser
        
        let postRef = Database.database().reference().child("Sharing_Photo")
      
        let newPostKey = postRef.childByAutoId().key!
        //let newPostRef = postRef.child(newPostId)
        
 //uploading description , user id , key
        postRef.childByAutoId().setValue(
            ["description":photoDescription.text!,
             "user":Auth.auth().currentUser?.email,
             "key":newPostKey])
    
        let storageRef = Storage.storage().reference(forURL: "gs://instagramcloneswift.appspot.com")
        let imageRef = storageRef.child("Sharing_Photo").child(user!.email!).child(uuid)
        
      //swift 5 change not yet providing
      // let downloadURL =
        //StorageReference.downloadURL((@escaping (URL?, Error?) -> Void) -> Void)
        
        imageRef.putFile(from: selectedImageUrl as! URL, metadata: nil) { metadata, error in
            if error != nil {
                print(error!)
                SVProgressHUD.showError(withStatus: "Upload Failed")
                return
            } else {
                SVProgressHUD.setMinimumDismissTimeInterval(1.0)
                
               //URL download fail error
                storageRef.downloadURL(completion: { (url, error) in
                    if error != nil {
                        print("Url downloard fail \(error)")
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
        }
        photoDescription.text = ""
        photoToShare.image = UIImage(named: "placeholder.png")
        tabBarController?.selectedIndex = 0
        selectedImage = nil
    }
    
    func sendDataToDatabase(photoUrl: String) {
        let ref = Database.database().reference()
        let postRef = ref.child("Sharing_Photo")
        let newPostId = postRef.childByAutoId().key!
        let newPostRef = postRef.child(newPostId)


        newPostRef.setValue(["phtoUrl":photoUrl, "description":photoDescription.text]) { (error, ref) in
            if error != nil {
                print("data upload fail")
             SVProgressHUD.showError(withStatus: error?.localizedDescription)
                return
            }
            print("data uploaded")
            SVProgressHUD.showSuccess(withStatus: "Success")
        }
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
}

