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
    let cellId = "PostCell"
    @IBOutlet weak var tableView: UITableView!
    
    @IBAction func goToComment(_ sender: Any) {
        performSegue(withIdentifier: "commentView", sender: nil)
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        tabBarController?.tabBar.isHidden = false
    }
    
    func loadPosts() {
        activityIndicatorView.startAnimating()
        Database.database().reference().child("Posts").observe(.childAdded) { (snapshot: DataSnapshot) in
            print(Thread.isMainThread)
            
            if  let dict = snapshot.value as? [String:Any]{
                // print("this is dict\(dict.values)")
                
                let newPost = Post.transFromPostPhoto(dict: dict)
                
                self.fetchUser(uid:newPost.uid!)
                
                self.posts.append(newPost)
                self.activityIndicatorView.stopAnimating()
                print(self.posts)
                self.tableView.reloadData()
            }
        }
    }
    
    
    func fetchUser(uid: String)  {
        
        
    }
    
    
    
    //MARK: - tableView methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! HomeUITableViewCell
        
        let post = posts[indexPath.row]
        
        cell.post = post
        //cell.updateHomeView(post: post)
        
        
        return cell
    }
}
