//
//  commentViewController.swift
//  instagramCloneSwift
//
//  Created by MyMac on 2019-05-12.
//  Copyright © 2019 Apex. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import SVProgressHUD

class commentViewController: UIViewController,UITableViewDataSource {
    
    @IBOutlet weak var tableViewOfCommets: UITableView!
    @IBOutlet weak var commentTextField: UITextField!
    @IBOutlet weak var sendButton: UIButton!
    
    var comments = [Comment]()
    //??
    var users = [User]()
    
    let cellId = "commentCell"
    let postId = "Lebw2XyQmNdGAbsOn44"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableViewOfCommets.dataSource  = self
        
        tableViewOfCommets.rowHeight = 77
        tableViewOfCommets.estimatedRowHeight = 600
        
      //  sendButton.isEnabled = false
        empty()
        handleTextField()
        loadComments()
     
    }
    
    func loadComments(){
       
        let postCommentRef = Database.database().reference().child("post-comments").child(self.postId)
        
        postCommentRef.observe(DataEventType.childAdded) { (snapshot) in
            print("observe key")
            print(snapshot.key)
            Database.database().reference().child("comments").child(snapshot.key).observeSingleEvent(of: DataEventType.value, with: { (snapshotComment) in
              //  print(snapshotComment.value)
                
                if  let dict = snapshotComment.value as? [String:Any]{
                    print("This is dictionary from snapshot.values")
                    print(dict.values)
                    
                    let newComment = Comment.transformComment(dict: dict)
                    
                    self.fetchUser(uid: newComment.uid!, completed: {
                        self.comments.append(newComment)
                        
                        //   self.activityIndicatorView.stopAnimating()
                        print("This is comments")
                        print(self.comments)
                        self.tableViewOfCommets.reloadData()
                    })
                }
            })
        }
    }
    
    //MARK: - Fetching Data
    func fetchUser(uid: String, completed: @escaping () -> Void) {
        
        Database.database().reference().child("users").child(uid).observeSingleEvent(of: DataEventType.value) { (snapshot:DataSnapshot) in
            
            if  let dict = snapshot.value as? [String:Any]{
                let user = User.transformUser(dict: dict)
                self.users.append(user)
                completed()
            }
        }
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        tabBarController?.tabBar.isHidden = true
    }
    
    
    
    @IBAction func sendButton_TouchUpInside(_ sender: Any) {
        
        let ref = Database.database().reference()
        let commentReference = ref.child("comments")
        let newCommentId = commentReference.childByAutoId().key
        let newCommentReference = commentReference.child(newCommentId)
        
        guard let currentUser = Auth.auth().currentUser else {
            return
        }
        
        let currentUserId = currentUser.uid
        
        newCommentReference.setValue([ "uid":currentUserId,
                            "commentText":commentTextField.text!
                            ]) { (error, ref) in
                                if error != nil {
                                    print("comment upload fail")
                    
                                    return
                                }
                                
                                let postCommentRef = Database.database().reference().child("post-comments").child(self.postId).child(newCommentId)
                                postCommentRef.setValue(true, withCompletionBlock: { (error, DatabaseReference) in
                                    if error != nil {
                                        SVProgressHUD.showError(withStatus: error?.localizedDescription)
                                    }
                                })
                                
                                
                                print("comment uploaded")
                                self.empty()
                    
                    
        }
    
    }
    
    func empty() {
        commentTextField.text = ""
        commentTextField.placeholder = "comment here"
        sendButton.isEnabled = false
        sendButton.setTitleColor(UIColor.lightGray, for: UIControl.State.normal)
    }
 
    
    //MARK: - Handling textField
    func handleTextField() {
        commentTextField.addTarget(self, action: #selector(self.textFieldDidChange), for: UIControl.Event.editingChanged)
    }

    @objc func textFieldDidChange() {
        if let commentText = commentTextField.text, !commentText.isEmpty {
            sendButton.setTitleColor(UIColor.black, for: UIControl.State.normal)
            sendButton.isEnabled = true
            return
        }
        sendButton.setTitleColor(UIColor.lightGray, for: UIControl.State.normal)
        sendButton.isEnabled = false
        
    }
    
    
    //MARK: - tableView methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return comments.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! commentTableViewCell
        
        let comment = comments[indexPath.row]
        let user = users[indexPath.row]
        
        cell.comment = comment
        cell.user = user
        
        
        return cell
        
    }

}
