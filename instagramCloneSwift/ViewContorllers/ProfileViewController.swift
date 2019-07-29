    //
    //  ProfileViewController.swift
    //  instagramCloneSwift
    //
    //  Created by MyMac on 2019-04-29.
    //  Copyright © 2019 Apex. All rights reserved.
    //
    
    import UIKit
    import SVProgressHUD
    
    class ProfileViewController: UIViewController, UINavigationControllerDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
        
    
        @IBOutlet weak var collectionView: UICollectionView!
        
        
        let storageRef = StorageReference.storageRef
        
        //  var selectedImage: UIImage?
        var user: UserModel!
        //initilizing with empty array
        var posts: [Post] = []
        
        override func viewDidLoad() {
            super.viewDidLoad()
            collectionView.dataSource = self
            collectionView.delegate = self
            fetchUser()
            fectchMyPosts()
            
        }
        
        
        //MARK: fetching User info
        func fetchUser() {
            Api.UserAPI.observeCurrentUser { (user) in
                
                self.user = user
                self.navigationItem.title = user.username
                self.collectionView.reloadData()
            }
        }
        
        
        //MARK: fecthincg Posts
        func fectchMyPosts() {
            //naming error used to occur ->user's photo can not be dicerned
            //Firebase User type was confused with custom type User.
            //currently class: User -> UserModel
            guard let currentUser = Api.UserAPI.CURRENT_USER else {
                return
            }
            
            Api.MyPostsAPI.fetchMyPosts(currentUser: currentUser.uid) { (key) in
                Api.PostAPI.observePost(withPostId: key, completion: { (post) in
                    //print("this is post in profileView")
                    // print(post.id)
                    self.posts.append(post)
                    self.collectionView.reloadData()
                })
            }
        }
        
        
        //MARK: - CollectionView Methods
        func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            return posts.count
        }
        
        func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCollectionViewCell" , for: indexPath) as! PhotoCollectionViewCell
            
            let post = posts.reversed()[indexPath.row]
            cell.post = post
            cell.delegateOfPhotoCollectionViewCell = self
            
            //delegateOfProfileViewController?.passingIndexPath(indexPath: indexPath)
            
              print("indexPath of cellForItemAt : \(indexPath)")
            
            
            return cell
        }
        
        
        //not called
        func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
            print("indexPath : \(indexPath)")
            
       
        }

        
        
//        @objc func handleLongPress(gestureReconizer: UILongPressGestureRecognizer) {
//            if gestureReconizer.state != UIGestureRecognizer.State.ended {
//                return
//            }
//
//            let p = gestureReconizer.location(in: self.collectionView)
//            let indexPath = self.collectionView.indexPathForItem(at: p)
//
//            if let index = indexPath {
//                var cell = self.collectionView.cellForItem(at: index)
//                // do stuff with your cell, for example print the indexPath
//               // println(index.row)
//            } else {
//           //     println("Could not find index path")
//            }
//        }
        
        
        func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
            
            let headerViewCell = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "HeaderProfileCollectionReusableView", for:indexPath) as! HeaderProfileCollectionReusableView
            
            // headerViewCell.updateView()
            
            if let user = self.user {
                headerViewCell.userInCell = user
                
                headerViewCell.degateOfHeaderProfileCollectionReusableView = self
                headerViewCell.thirdDegateOfHeaderProfileCollectionReusableView = self
            }
            
            
            
            return headerViewCell
        }
        
        
      
        
        
        //MARK: - cell size
        
        // it needs delegate to work
        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            return CGSize(width: collectionView.frame.size.width / 3  , height: collectionView.frame.size.width / 3  )
        }
        
        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
            return -2
        }
        
        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
            return 0
        }
        
      
        
//
//        func logout(){
//            AuthService.logOut(onSuccess: {
//                let storyboard =  UIStoryboard(name: "Main", bundle: nil)
//
//                let logInVC = storyboard.instantiateViewController(withIdentifier: "LogInViewController")
//
//                self.present(logInVC, animated: true, completion: nil)
//
//            }) { (logOutError) in
//                SVProgressHUD.showError(withStatus: logOutError)
//            }
//        }
//
        
    }
    
  
    
    
    
    extension ProfileViewController: HeaderProfileCollectionReusableViewDelegate, UIImagePickerControllerDelegate {
        
        func takeProfileImage() {
            
            print("takeProfileImage called")
            
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            present(imagePicker, animated: true, completion:nil)
            print("tapped")
        }
        
        
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            print("did finish picking image")
            
            //            let currentUser = Api.UserAPI.CURRENT_USER
            
            guard let currentUser = Api.UserAPI.CURRENT_USER else {
                return
            }
            //  var profileImageRef = storageRef.child("profile_photo").child(currentUser.email!)
            
            

            
            let selectedImageUrl = info[.imageURL]
            
            let profileImageRef = storageRef.child("profile_photo").child(currentUser.email!)
            
            profileImageRef.putFile(from: selectedImageUrl as! URL, metadata: nil) { metadata, error in
                if error != nil {
                    return
                } else {
                    //downloading Profile Image Url
                    profileImageRef.downloadURL(completion: { (url, error) in
                        if error != nil {
                            print("Download URL fail")
                            // print(error)
                            print("profileImageRef: \(profileImageRef)")
                            return
                        }else {
                            let profilePhotoUrl  = url?.absoluteString
                            
                            self.sendDataToDatabase(profilePhotoUrl: profilePhotoUrl!)
                            
                            //self.header?.profileImage.sd_setImage(with: url)
                            
                            
                            // self.collectionView.reloadData()
                            
                        }
                    })
                    
                    print("image uploaded")
                    return
                }
            }
            //  print(info)
            
            dismiss(animated: true, completion: nil)
            print("dissmissed")
            self.collectionView.reloadData() //doesn't work for updating profileImage instantly
            
            // self.header!.updateView()
            
        }
        
        func sendDataToDatabase(profilePhotoUrl: String) {
            
            guard let currentUser = Api.UserAPI.CURRENT_USER else {
                return
            }
            
            print("sendDataToDatabase called")
            let postRef = Api.UserAPI.REF_USERS
            let newPostId = postRef.child(currentUser.uid)
            
            newPostId.updateChildValues(["profileImageUrl":profilePhotoUrl]) { (error, DatabaseReference) in
                if error != nil {
                    print("data upload fail")
                    SVProgressHUD.showError(withStatus: error?.localizedDescription)
                    return
                }
                print("data uploaded")
                // self.header?.updateView() //doesn't work for updating profileImage instantly
                
                //self.collectionView.reloadData()
                SVProgressHUD.showSuccess(withStatus: "Success")
            }
        }
        
        //        func updateProfileImage(forUser userInCell:UserModel){
        //
        //            if let photoUrlString = userInCell.profileImageUrl {
        //                let photoUrl = URL(string: photoUrlString)
        //
        //                header.profileImage.sd_setImage(with: photoUrl)
        //
        //
        //                print("updateProfileImage")
        //            }
        //collectionView.reloadData()
        //
        //        }
        
        
        
        
        
    }
    
    extension ProfileViewController: SettingUITableViewControllerDelegate {
        
        func updateUserInfoRealTime() {
            
            self.fetchUser()
            
        }
    }
    
    
    extension ProfileViewController: HeaderProfileCollectionReusableViewThirdDelegate {
        func goToFollowingVC() {
            
            performSegue(withIdentifier: "Profile_Following", sender: user.id)
        }
        
        func goToFollowerVC() {
            performSegue(withIdentifier: "Profile_Follower", sender: user.id)
        }
        
        
        func goToSettingVC() {
            
            performSegue(withIdentifier: "Profile_SettingSegue", sender: nil
                
            )
        }
        
    }
    
    extension ProfileViewController: PhotoCollectionViewCellDelegate {
        
        func goToProfileTableVCFromProfileVC(userId: String) {
            print("user.id from profileVC \(user.id)")
            performSegue(withIdentifier: "Profile_ProfileTable", sender: user.id)
          
        }
        
        
        //MARK: - Prepare for segue
        override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            
            if segue.identifier == "Profile_SettingSegue" {
                
                let settingVC = segue.destination as? SettingUITableViewController
                
                settingVC?.delegateOfSettingUITableViewController = self
                
            }
            
            if segue.identifier == "Profile_ProfileTable" {
                
                let profileTableVC = segue.destination as? ProfileTableViewController
                
                let userId = sender as? String
                
                profileTableVC!.userId = userId!
            }
            
            if segue.identifier == "Profile_Following" {
                
                let followingVC = segue.destination as? FollowingViewController
                
                let userId = sender as? String
                print("userId PVC : \(userId)")
                followingVC!.userId = userId!
            }
            
            if segue.identifier == "Profile_Follower" {
                
                let followVC = segue.destination as? FollowerViewController
                
                let userId = sender as? String
                print("userId PUVC : \(userId)")
                followVC!.userId = userId!
            }

            
        }
        
    }

    
    
