 //
//  ProfileUserViewController.swift
//  instagramCloneSwift
//
//  Created by MyMac on 2019-06-10.
//  Copyright © 2019 Apex. All rights reserved.
//

import UIKit

 class ProfileUserViewController: UIViewController,UINavigationControllerDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var userName: UILabel!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var secondDelegateOfHeaderProfileCollectionReusableViewInPUVC: HeaderProfileCollectionReusableViewSecondDelegate?
    
    var delegateofSettingUITableViewControllerInPUVC:SettingUITableViewControllerDelegate?
    
    
    var user: UserModel!
    //initilizing with empty array
    var posts: [Post] = []
    var userId = ""
    var usersInCell = [UserModel]()
    let cellId = "usersCell"
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        print("userId : \(userId)")
        collectionView.dataSource = self
        collectionView.delegate = self
        fetchUser()
        fectchMyPosts()
        
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
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCollectionViewCell" , for: indexPath) as! PhotoCollectionViewCell
        
        let post = posts[indexPath.row]
        
        cell.post = post
        
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ProfileUser_SettingSegue" {
            
            let settingVC = segue.destination as? SettingUITableViewController
            
          //  settingVC?.delegateOfSettingUITableViewController = self.delegateofSettingUITableViewControllerInPUVC
            
        }
    }
 
 }
