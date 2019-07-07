 //
 //  ProfileUserViewController.swift
 //  instagramCloneSwift
 //
 //  Created by MyMac on 2019-06-10.
 //  Copyright © 2019 Apex. All rights reserved.
 //
 
 import UIKit
 
 protocol ProfileUserViewControllerIndexDelegate {
    func passIndexPath(indexPath:IndexPath)
 }
 
 class ProfileUserViewController: UIViewController, UINavigationControllerDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    var delegate: ProfileUserViewControllerIndexDelegate?
    
    @IBOutlet weak var userName: UILabel!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var secondDelegateOfHeaderProfileCollectionReusableViewInPUVC: HeaderProfileCollectionReusableViewSecondDelegate?
    
    var delegateofSettingUITableViewControllerInPUVC:SettingUITableViewControllerDelegate?
    
    var indexPath: IndexPath?
    var user: UserModel!
    //initilizing with empty array
    var posts: [Post] = []
    var userId = ""
    var usersInCell = [UserModel]()
    let cellId = "usersCell"
   
  
    
  
    //tap.cancelsTouchesInView = false
    //view.addGestureRecognizer(tap)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("userId : \(userId)")
        collectionView.dataSource = self
        collectionView.delegate = self
        fetchUser()
        fectchMyPosts()
        
//         let tap = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
//       
//     
//        
//        tap.cancelsTouchesInView = false
//        
//         view.addGestureRecognizer(tap)
        
    }
    
    
    //MARK: fetching User info
    func fetchUser() {
        Api.UserAPI.observeUser(withUserId: userId) { (user) in
            self.isFollowing(userId: user.id!, completed: { (boolValue) in
                
                user.isFollowed = boolValue
                
                self.user = user
                self.navigationItem.title = user.username
                self.collectionView.reloadData()
                
            })
            
            
            
        }
    }
    
    func isFollowing(userId: String, completed:@escaping(Bool) -> Void){
        Api.FollowAPI.isFollowing(userId: userId, completed: completed)
    }
    
    
    
    //MARK: fecthincg Posts
    func fectchMyPosts() {
        Api.MyPostsAPI.REF_MYPOSTS.child(userId).observe(.childAdded) { (snapshot) in
            
            Api.PostAPI.observePost(withPostId: snapshot.key, completion: { (post) in
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
        
        print("cellForItemAt")
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCollectionViewCell" , for: indexPath) as! PhotoCollectionViewCell
        
        let post = posts[indexPath.row]
        
        cell.post = post
        cell.delegateOfPhotoCollectionViewCell = self
      //  cell.
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        let headerViewCell = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "HeaderProfileCollectionReusableView", for:indexPath) as! HeaderProfileCollectionReusableView
        
        headerViewCell.updateView()
        
        if let user = self.user {
            headerViewCell.userInCell = user
            
            headerViewCell.secondDegateOfHeaderProfileCollectionReusableViewInHPCRV = self.secondDelegateOfHeaderProfileCollectionReusableViewInPUVC
            
            
            
            headerViewCell.thirdDegateOfHeaderProfileCollectionReusableView = self
            
        }
        
        return headerViewCell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
         print("indexPath")
        
        // delegate?.passIndexPath(indexPath: indexPath)
        print("indexPath: \(indexPath)")
        return  self.indexPath = indexPath
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
    
  
    
    
 
    
    
 }
 
 extension ProfileUserViewController: HeaderProfileCollectionReusableViewThirdDelegate {
    
    func goToSettingVC() {
        performSegue(withIdentifier: "ProfileUser_SettingSegue", sender: nil )
    }
 }
 
 
 
 extension ProfileUserViewController: PhotoCollectionViewCellDelegate {
    
    func goToProfileTableVC(userId: String) {
        
        performSegue(withIdentifier: "ProfileUser_ProfileTable", sender: userId)
        print("ProfileUser_ProfileTable")
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "ProfileUser_SettingSegue" {
            
            // let settingVC = segue.destination as? SettingUITableViewController
            
            // displaying ProfilePhoto in realtime Not Yet Working
            //  settingVC?.delegateOfSettingUITableViewController = self.delegateofSettingUITableViewControllerInPUVC
            
        }
        
        if segue.identifier == "ProfileUser_ProfileTable" {
            
            let profileTableVC = segue.destination as? ProfileTableViewController
            
            let userId = sender as? String
            
            profileTableVC!.userId = userId!
        }
    }
    
 }
