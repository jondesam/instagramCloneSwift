//
//  DetailViewController.swift
//  instagramCloneSwift
//
//  Created by MyMac on 2019-06-27.
//  Copyright © 2019 Apex. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    var postId:String = ""
    var post =  Post()
    var user = UserModel()
    var cellId = "PostCell"
    
   
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        loadPost()
        print(postId)
        
        tableView.estimatedRowHeight = 600
       // tableView.rowHeight = UITableView.automaticDimension //doesn't work
        // Do any additional setup after loading the view.
    }
    
    func loadPost(){
        Api.PostAPI.observePost(withPostId: postId) { (post) in
            
            guard let postUid = post.uid  else {
             return
            }
            
            self.fetchUser(uid: postUid, completed: {
                
                self.post = post
                
                self.tableView.reloadData()
            })
        }
    }
    
    func fetchUser(uid:String, completed: @escaping () -> Void) {
        
        Api.UserAPI.observeUser(withUserId: uid) { (userModel) in
            
            self.user = userModel
        
            completed()
        }
    }
    
  
}

extension DetailViewController : UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId , for: indexPath) as! HomeUITableViewCell
//
//        let post = post[indexPath.row]
//        let user = user[indexPath.row]
//
        
        cell.post = post
        cell.userInCell = user
        cell.delegateOfHomeUITableViewCell = self
        return cell
    }
    
 
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "Detail_commentVC" {
            let commentVC = segue.destination as! commentViewController
            let postId = sender as! String
            commentVC.postId = postId
        }
        
        if segue.identifier == "Detail_profileUserVC" {
            let profileUserVC = segue.destination as! ProfileUserViewController
            let userId = sender as! String
            profileUserVC.userId = userId
            ///
            //            profileUserVC.delegateofSettingUITableViewControllerInPUVC = self
        }
        
        
        
    }
    
  
    
    
}

extension DetailViewController: HomeUITableViewCellDelegate //Intern of GoToCommentVcProtocol
{
    func goToCommentVC(postId: String) {
        performSegue(withIdentifier: "Detail_commentVC" , sender: postId)
    }
    func goToProfileUserVC(userId: String) {
        performSegue(withIdentifier: "Detail_profileUserVC", sender: userId)
    }
    
}
