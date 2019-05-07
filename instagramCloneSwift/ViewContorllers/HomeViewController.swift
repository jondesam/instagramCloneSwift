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

class HomeViewController: UIViewController,UITableViewDataSource {
 
    let cellId = "PostCell"
   
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        //SVProgressHUD.dismiss()
        tableView.dataSource = self
        loadPosts()
        print(Auth.auth().currentUser?.email as Any)
     //   var post = Post(descriptionText: "test", keyString: "key test")
        
//        print(post.description)
//        print(post.key)
    }
    
    func loadPosts() {
        Database.database().reference().child("Sharing_Photo").observe(.childAdded) { (snapshop: DataSnapshot) in
            //print(snapshop.value)
            if let dict = snapshop.value as? [String:Any]{
                print(dict)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 100
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
        
        cell.textLabel?.text = "\(indexPath.row)"
        cell.backgroundColor = UIColor.red
        return cell
    }
   
    


}
