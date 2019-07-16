//
//  HomeViewController.swift
//  instagramCloneSwift
//
//  Created by MyMac on 2019-04-29.
//  Copyright © 2019 Apex. All rights reserved.
//

import UIKit
import SVProgressHUD
import SDWebImage

class HomeViewController: UIViewController,UITableViewDataSource
{
    
    var postz = [Post]()
    var userz = [UserModel]()
    let cellId = "PostCell"
    
    @IBOutlet weak var tableView: UITableView!
    
//    @IBAction func goToComment(_ sender: Any) {
//        performSegue(withIdentifier: "commentSegue", sender: nil)
//    }
    
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        
        tableView.rowHeight = 440
        tableView.estimatedRowHeight = 600
         //tableView.rowHeight = UITableView.automaticDimension //doesn't work
        loadPosts()
       
        self.activityIndicatorView.stopAnimating()
        
    }
    
   
    
    
    func loadPosts() {
        activityIndicatorView.startAnimating()
        
        Api.FeedAPI.observeFeed(withUserId: Api.UserAPI.CURRENT_USER!.uid) { (post) in
            
            guard let postId = post.uid else {
                return
            }// post.uid = userID
            
            self.fetchUser(uid: postId, completed: {
                                self.postz.append(post)
                                self.activityIndicatorView.stopAnimating()
                                self.tableView.reloadData()
                            })
             
        }
        
       Api.FeedAPI.observeFeedRemoved(withUserId: Api.UserAPI.CURRENT_USER!.uid) { (post) in
           // print(key)
            
            //removing post For-In Loops
//            for (index, postInstance) in self.posts.enumerated(){
//                if postInstance.id == key {
//                    self.posts.remove(at: index)
//                }
//            }
            
            //prone to error
//            self.posts = self.posts.filter({ (post) -> Bool in
//                post.id != key
//            })

            self.postz = self.postz.filter({ $0.id != post.id })
            self.userz = self.userz.filter({ $0.id != post.uid })
            self.tableView.reloadData()
        }
        
//        Api.PostAPI.observePosts { (newPost) in
//
//            self.fetchUser(uid: newPost.uid!, completed: {
//
//                self.posts.append(newPost)
//                self.activityIndicatorView.stopAnimating()
//                self.tableView.reloadData()
//            })
//        }
    
    }
    
    
    func fetchUser(uid: String, completed: @escaping () -> Void ){
       
        Api.UserAPI.observeUser(withUserId: uid) { (user) in
            //print("\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\")
            //dump("This is user from observeUSer \(user)")
            self.userz.append(user)
            //dump("This is users from obseveUser \(self.users)")
            completed()
        }
    }
    
    
    //MARK: - tableView methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        print("post count \(postz.count)")
//        print("user count \(userz.count)")
        return postz.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! HomeUITableViewCell

        let post = postz.reversed()[indexPath.row]
        let user = userz.reversed()[indexPath.row]
        
       // dump(post)
        cell.post = post
  
        cell.userInCell = user
        
       // cell.homeVC = self //delegation pattern is used instead
     
        cell.delegateOfHomeUITableViewCell = self
        
        return cell
    }
    
    
 
    
    //to transfer sender from "performsegue" method in HomeUITableViewCell
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "commentSegue" {
            let commentVC = segue.destination as! commentViewController
            let postId = sender as! String
            commentVC.postId = postId
        }
        
        if segue.identifier == "Home_ProfileSegue" {
            let profileUserVC = segue.destination as! ProfileUserViewController
            let userId = sender as! String
            profileUserVC.userId = userId
            ///
//            profileUserVC.delegateofSettingUITableViewControllerInPUVC = self
        }
        
        
        if segue.identifier == "Home_HashTagSegue" {
            let hashTagVC = segue.destination as! HashTagViewController
            let tag = sender as! String
            hashTagVC.tag = tag
        }
        
        
    }

}

extension HomeViewController: HomeUITableViewCellDelegate //Intern of GoToCommentVcProtocol
{
    func goToHashTag(tag: String) {
        performSegue(withIdentifier: "Home_HashTagSegue", sender: tag )
    }
    
    func goToCommentVC(postId: String) {
        performSegue(withIdentifier: "commentSegue" , sender: postId)
    }
    
    func goToProfileUserVC(userId: String) {
        performSegue(withIdentifier: "Home_ProfileSegue", sender: userId)
    }
    
}

//extension HomeViewController: SettingUITableViewControllerDelegate {
//    
//    func updateUserInfoRealTime() {
//        
//        self.loadPosts()
//        
//    }
//}
