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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //SVProgressHUD.dismiss()
        tableView.dataSource = self
        
        
        tableView.rowHeight = 440
        tableView.estimatedRowHeight = 600
        loadPosts()
        print(Auth.auth().currentUser?.email as Any)
    
    }
    
    func loadPosts() {
        Database.database().reference().child("Posts").observe(.childAdded) { (snapshop: DataSnapshot) in
            print(Thread.isMainThread)
            
            if  let dict = snapshop.value as? [String:Any]{
               // print("this is dict\(dict.values)")
                
              //  let post = Post()
                let newPost = Post.transFromPostPhoto(dict: dict)
                
                
                self.posts.append(newPost)
                print(self.posts)
                self.tableView.reloadData()
                
            }
        }
    }
    

    
    //MARK: - tableView methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! HomeUITableViewCell
        let post = posts[indexPath.row]
        
        cell.descriptionLabel.text = post.description
        cell.profileImageView.image = UIImage(named: "photo1.jpeg")
        cell.nameLabel.text = "Jos"
        
        print(post.photoURL)
        if let photoUrlString = post.photoURL {
         let photoUrl = URL(string: photoUrlString)
            print("photoUrl: \(photoUrl)")
            cell.postImageView.sd_setImage(with: photoUrl)
            
    }


return cell
}
}
