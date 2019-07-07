//
//  ProfileTableViewController.swift
//  instagramCloneSwift
//
//  Created by MyMac on 2019-07-04.
//  Copyright © 2019 Apex. All rights reserved.
//

import UIKit

class ProfileTableViewController: UITableViewController,ProfileUserViewControllerIndexDelegate {
    
  
    

    var postz = [Post]()
    var userz = [UserModel]()
    let cellId = "PostCell"
    var userId: String?
    var indexPath: IndexPath?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("userId : \(userId)")

        print("ProfileTableViewController")
        tableView.delegate = self
        tableView.dataSource = self
     
        tableView.rowHeight = 440
        tableView.estimatedRowHeight = 600
        loadPosts()
       // passIndexPath(indexPath: indexPath!)
    }

    
    func passIndexPath(indexPath: IndexPath) {
        self.indexPath = indexPath
    }
    
    func loadPosts() {
      //  activityIndicatorView.startAnimating()
        
        Api.MyPostsAPI.fetchMyPosts(currentUser: userId!) { (key) in
            Api.PostAPI.observePost(withPostId: key, completion: { (post) in
              
                self.fetchUser(uid: self.userId!, completed: {
                    self.postz.append(post)
                   // self.activityIndicatorView.stopAnimating()
                    self.tableView.reloadData()
                    
                    //self.tableView.scrollToRow(at: self.indexPath!, at: UITableView.ScrollPosition.none, animated: true)
                })
            })
        }
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
    
    
    
    // MARK: - Table view data source

//    override func numberOfSections(in tableView: UITableView) -> Int {
//        // #warning Incomplete implementation, return the number of sections
//        return 1
//    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return postz.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! HomeUITableViewCell
        
        let post = postz.reversed()[indexPath.row]
        let user = userz.reversed()[indexPath.row]
        
        cell.post = post
        
        cell.userInCell = user
        
        // cell.homeVC = self //delegation pattern is used instead
        
        cell.delegateOfHomeUITableViewCell = self
        
        return cell
        
    }
    
 

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension ProfileTableViewController: HomeUITableViewCellDelegate //Intern of GoToCommentVcProtocol
{
    func goToCommentVC(postId: String) {
        performSegue(withIdentifier: "ProfileTable_comment" , sender: postId)
    }
    func goToProfileUserVC(userId: String) {
        performSegue(withIdentifier: "ProfileTable_profileUser", sender: userId)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "ProfileTable_comment" {
            let commentVC = segue.destination as! commentViewController
            let postId = sender as! String
            commentVC.postId = postId
        }
        
        if segue.identifier == "ProfileTable_profileUser" {
            let profileUserVC = segue.destination as! ProfileUserViewController
            let userId = sender as! String
            profileUserVC.userId = userId
            ///
            //            profileUserVC.delegateofSettingUITableViewControllerInPUVC = self
        }
        
        
        
    }
    
}
