    //
    //  HeaderProfileCollectionReusableView.swift
    //  instagramCloneSwift
    //
    //  Created by MyMac on 2019-05-25.
    //  Copyright © 2019 Apex. All rights reserved.
    //

    import UIKit
    protocol HeaderProfileCollectionReusableViewDelegate {
        func takeProfileImage()
    }
    
    
    class HeaderProfileCollectionReusableView: UICollectionReusableView,  UIImagePickerControllerDelegate,UINavigationControllerDelegate {
        
        
        @IBOutlet weak var profileImage: UIImageView!
        @IBOutlet weak var nameLable: UILabel!
        @IBOutlet weak var myPostCountLabel: UILabel!
        @IBOutlet weak var followingCountLabel: UILabel!
        @IBOutlet weak var followersCountLabel: UILabel!
     
        
        let storageRef = StorageReference.storageRef
        let currentuser = Api.UserAPI.CURRENT_USER
        lazy var profileImageRef = storageRef.child("profile_photo").child(currentuser!.email!)
        
        
        var selectedImage: UIImage?
        
        var degateOfHeaderProfileCollectionReusableView: HeaderProfileCollectionReusableViewDelegate?
        
     
        
        var userInCell: UserModel? {
            didSet {
                updateView()
            }
        }
     
        
        
        func  updateView() {
     
            profileImage.layer.masksToBounds = false
            profileImage.layer.borderColor = UIColor.white.cgColor
            profileImage.layer.cornerRadius =  profileImage.frame.height/2
            profileImage.clipsToBounds = true
            
            
            if let user = userInCell {
                self.nameLable.text = user.username
                
                if let photoUrlString = user.profileImageUrl {
                    let photoUrl = URL(string: photoUrlString)
                    self.profileImage.sd_setImage(with: photoUrl)
                }
            }
           
            
    }
        
        

        
    
        override func awakeFromNib() {
            super.awakeFromNib()
            
           
            //Aloow user to touch imageView as button
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.profileImage_TouchUpInside))
            
            profileImage.addGestureRecognizer(tapGesture)
            profileImage.isUserInteractionEnabled = true
            print("profileImage Tapped")
            
            
        }
        
        @objc func profileImage_TouchUpInside() {

            degateOfHeaderProfileCollectionReusableView?.takeProfileImage()
                
        }

        

}

   
