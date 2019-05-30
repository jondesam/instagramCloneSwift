    //
    //  ProfileViewController.swift
    //  instagramCloneSwift
    //
    //  Created by MyMac on 2019-04-29.
    //  Copyright © 2019 Apex. All rights reserved.
    //

    import UIKit
    
    import SVProgressHUD

    class ProfileViewController: UIViewController,UIImagePickerControllerDelegate, UINavigationControllerDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
        
        @IBOutlet weak var collectionView: UICollectionView!
        
        var user: User!
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
            Api.UserAPI.observeCurrentUse { (user) in
                
                self.user = user
                self.collectionView.reloadData()
            }
        }
        
        
        //MARK: fecthincg Posts
        func fectchMyPosts() {
          
            
        
        let currentUserUid = Api.UserAPI.CURRENT_USER_UID
            Api.MyPosts.REF_MYPOSTS.child(currentUserUid!).observe(.childAdded) { (snapshot) in
                print("snapshot of myPosts")
                print(snapshot)
                
                Api.PostAPI.observePost(withId: snapshot.key, completion: { (post) in
                    print("this is post in profileView")
                 //   print(post.id)
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
                  headerViewCell.user = user
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
        
        
        
        
        //MARK: - Logout method
        @IBAction func buttonLogOut(_ sender: Any) {
            
            AuthService.logOut(onSuccess: {
                let storyboard =  UIStoryboard(name: "Main", bundle: nil)
                
                let logInVC = storyboard.instantiateViewController(withIdentifier: "LogInViewController")
                
               self.present(logInVC, animated: true, completion: nil)
                
            }) { (logOutError) in
                SVProgressHUD.showError(withStatus: logOutError)
            }
            
            
            
            
            
   
        
        
    }




    }





