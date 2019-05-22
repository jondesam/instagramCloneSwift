//
//  HomeViewController.swift
//  instagramCloneSwift
//
//  Created by MyMac on 2019-04-29.
//  Copyright © 2019 Apex. All rights reserved.
//

import UIKit
import FirebaseAuth
import SVProgressHUD
import FirebaseDatabase
import SDWebImage

class HomeViewController: UIViewController,UITableViewDataSource {
    
    var posts = [Post]()
    var users = [User]()
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
        print(Auth.auth().currentUser?.email as Any)
        
    }
    
          func loadPostsOri() {
            activityIndicatorView.startAnimating()
            Database.database().reference().child("Posts").observe(.childAdded) { (snapshot: DataSnapshot) in
    
                if  let dict = snapshot.value as? [String:Any]{
    
                    let newPost = Post.transFromPostPhoto(dict: dict, key: snapshot.key)
    
                    self.fetchUser(uid: newPost.uid!, completed: {
                        self.posts.append(newPost)
                        self.activityIndicatorView.stopAnimating()
                        self.tableView.reloadData()
                    })
                }
            }
        }
    
    
    func loadPosts() {
        activityIndicatorView.startAnimating()
        
        Api.PostAPI.observePosts { (newPost) in
            
            self.fetchUser(uid: newPost.uid!, completed: {
                
                self.posts.append(newPost)
                self.activityIndicatorView.stopAnimating()
                self.tableView.reloadData()
            })
        }
    }
    
    func fetchUser(uid: String, completed: @escaping () -> Void) {
       
            Api.UserAPI.observeUsers(withId: uid) { (user) in
            self.users.append(user)
            completed()
        }
    }
    
    
    func fetchUserOri(uid: String, completed: @escaping () -> Void) {
        Database.database().reference().child("users").child(uid).observeSingleEvent(of: DataEventType.value) { (snapshot:DataSnapshot) in

            if  let dict = snapshot.value as? [String:Any]{
                let user = User.transformUser(dict: dict)
                self.users.append(user)
//                print("This is users")
//                dump(self.users)
                completed()
                }
            }
        }
    
    
    
    //MARK: - tableView methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! HomeUITableViewCell
        print(indexPath.row)
        let post = posts[indexPath.row]
        let user = users[indexPath.row]
        
        print("This is post")
        dump(post)
        
        cell.post = post
        cell.user = user
        
        print("This is cell.post")
        dump(cell.post)
//        print("This is cell.user")
//        dump(cell.user)
       
    
        cell.homeVC = self
     
       // print("This is cell.homeVC")
       // dump(cell.homeVC)
        //cell.updateHomeView(post: post)
        
        print("This is cell")
        dump(cell)
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
