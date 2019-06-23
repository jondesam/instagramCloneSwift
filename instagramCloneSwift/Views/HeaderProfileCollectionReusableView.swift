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
        
        //func updateProfileImage(forUser userInCell:UserModel)
       
    }
    
    protocol HeaderProfileCollectionReusableViewSecondDelegate {
        
         func updateFollowButton(forUser userInCell: UserModel)
    }

    
    class HeaderProfileCollectionReusableView: UICollectionReusableView,  UIImagePickerControllerDelegate {
        
        @IBOutlet weak var profileImage: UIImageView!
        @IBOutlet weak var nameLable: UILabel!
        @IBOutlet weak var myPostCountLabel: UILabel!
        @IBOutlet weak var followingCountLabel: UILabel!
        
        @IBOutlet weak var followerCountLabel: UILabel!
        
        @IBOutlet weak var followOrEditButton: UIButton!
        
        var degateOfHeaderProfileCollectionReusableView: HeaderProfileCollectionReusableViewDelegate?
        
        var secondDegateOfHeaderProfileCollectionReusableViewInHPCRV:HeaderProfileCollectionReusableViewSecondDelegate?
        
        var userInCell: UserModel? {
            didSet {
                
                updateView()
                
               // print(Api.UserAPI.CURRENT_USER?.uid)
                //degateOfHeaderProfileCollectionReusableView?.updateProfileImage(forUser: userInCell!)
            }
        }
     
        

        func  updateView() {
            
        
            profileImage.layer.masksToBounds = false
            profileImage.layer.borderColor = UIColor.white.cgColor
            profileImage.layer.cornerRadius =  profileImage.frame.height/2
            profileImage.clipsToBounds = true
            
           if let user = userInCell {
            
            
           
                
            Api.MyPostsAPI.fetchCountMyPosts(userId:userInCell!.id! , completion: { (postCount) in

                     self.myPostCountLabel.text = "\(postCount)"
                })
            
            
            Api.FollowAPI.fetchCountFollowing(userId: (userInCell?.id!)!) { (followingNumber) in
                self.followingCountLabel.text = "\(followingNumber - 1)"
            }
            
            Api.FollowAPI.fetchCountFollowers(userId: (userInCell?.id!)!) { (followersNumber) in
                self.followerCountLabel.text = "\(followersNumber - 1)"
            }
            
            
            self.nameLable.text = userInCell?.username
                
            if let photoUrlString = userInCell?.profileImageUrl {
                    let photoUrl = URL(string: photoUrlString)
                    self.profileImage.sd_setImage(with: photoUrl)
                }
                
                if userInCell?.id == Api.UserAPI.CURRENT_USER?.uid {
                    
                   followOrEditButton.setTitle("Edit Prof", for: UIControl.State.normal)
                } else {
                    updateStateFollowButton()
                }
                
            }
            
           
    }
   
        
        override func awakeFromNib() {
            super.awakeFromNib()
            //degateOfHeaderProfileCollectionReusableView?.updateProfileImage(forUser: userInCell!)
           
            // updateView()
            
            //Aloow user to touch imageView as button
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.profileImage_TouchUpInside))
            
            profileImage.addGestureRecognizer(tapGesture)
            profileImage.isUserInteractionEnabled = true

            
        }
        
        @objc func profileImage_TouchUpInside() {

        degateOfHeaderProfileCollectionReusableView?.takeProfileImage()
                
        }

        
   
        
        
        func updateStateFollowButton() {
            if userInCell?.isFollowed! == true {
                configureUnfollowButton()

            } else {
                configureFollowButton()
            }
            
        }
        

        
        func configureFollowButton(){
            followOrEditButton.layer.borderWidth = 1
            followOrEditButton.layer.borderColor = UIColor(red: 226/255, green: 228/255, blue: 232/255, alpha:1).cgColor
            followOrEditButton.layer.cornerRadius = 5
            followOrEditButton.backgroundColor = UIColor(red: 69/255, green: 142/255, blue: 255/255, alpha: 1)
            followOrEditButton.setTitleColor(UIColor.white, for: UIControl.State.normal)
            
            
            followOrEditButton.setTitle("follow", for: UIControl.State.normal)
            followOrEditButton.addTarget(self, action: #selector(self.followAction), for: UIControl.Event.touchUpInside)
            
        }
        
        func configureUnfollowButton(){
            
            followOrEditButton.layer.borderWidth = 1
            followOrEditButton.layer.borderColor = UIColor(red: 226/255, green: 228/255, blue: 232/255, alpha:1).cgColor
            followOrEditButton.layer.cornerRadius = 5
            followOrEditButton.clipsToBounds = true
            followOrEditButton.setTitleColor(UIColor.black, for: UIControl.State.normal)
            followOrEditButton.backgroundColor = UIColor.clear
            
            
            followOrEditButton.setTitle("following", for: UIControl.State.normal)
            
            followOrEditButton.addTarget(self, action: #selector(self.unFollowAction), for: UIControl.Event.touchUpInside)
        }
        
        
        @objc func followAction()  {
            
            if userInCell!.isFollowed! == false {
                Api.FollowAPI.followAction(idInCell: userInCell!.id!)
                
                // to allow button have 2 ways both follow and Unfollow
                configureUnfollowButton()
                userInCell!.isFollowed! = true
                
                secondDegateOfHeaderProfileCollectionReusableViewInHPCRV?.updateFollowButton(forUser: userInCell!)
            }
            
            /*before updatng cell directly
             // this causes haavy duty on view
             Api.FollowAPI.followAction(idInCell: userInCell!.id!)
             
             // to allow button have 2 ways both follow and Unfollow
             configureUnfollowButton()
             */
        }
        
        @objc func unFollowAction() {
            if userInCell!.isFollowed! == true {
                Api.FollowAPI.unFollowAction(withUser: userInCell!.id!)
                
                // to make button have 2 ways both follow and Unfollow
                configureFollowButton()
                userInCell!.isFollowed! = false
                
                secondDegateOfHeaderProfileCollectionReusableViewInHPCRV?.updateFollowButton(forUser: userInCell!)
            }
            
            /*before updatng cell directly
             // this causes haavy duty on view
             Api.FollowAPI.unFollowAction(withUser: userInCell!.id!)
             
             // to make button have 2 ways both follow and Unfollow
             configureFollowButton()
             */
        }
        
        
        
}

   
