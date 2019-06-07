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

class HomeViewController: UIViewController,UITableViewDataSource {
    
    var posts = [Post]()
    var users = [UserModel]()
    let cellId = "PostCell"
    
    @IBOutlet weak var tableView: UITableView!
    @IBAction func goToComment(_ sender: Any) {
        performSegue(withIdentifier: "commentSegue", sender: nil)
    }
    
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        
        tableView.rowHeight = 440
        tableView.estimatedRowHeight = 600
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
                
                                self.posts.append(post)
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

            self.posts = self.posts.filter({ $0.id != post.id })
            self.users = self.users.filter({ $0.id != post.uid })
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
            self.users.append(user)
            //dump("This is users from obseveUser \(self.users)")
            completed()
        }
    }
    
    
    //MARK: - tableView methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("post count \(posts.count)")
        print("user count \(users.count)")
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! HomeUITableViewCell

        let post = posts[indexPath.row]
        let user = users[indexPath.row]
        
        cell.post = post
        cell.user = user
        
        cell.homeVC = self
     
        return cell
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "commentSegue" {
            let commentVC = segue.destination as! commentViewController
            let postId = sender as! String
            commentVC.postId = postId
        }
    }
}
