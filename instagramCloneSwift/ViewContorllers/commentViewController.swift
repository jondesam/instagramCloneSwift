//
//  commentViewController.swift
//  instagramCloneSwift
//
//  Created by MyMac on 2019-05-12.
//  Copyright © 2019 Apex. All rights reserved.
//

import UIKit
import Firebase
import SVProgressHUD

class commentViewController: UIViewController,UITableViewDataSource{
    
    @IBOutlet weak var tableViewOfCommets: UITableView!
    @IBOutlet weak var commentTextField: UITextField!
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var constraintToBotton: NSLayoutConstraint!
    
    var comments = [Comment]()
    var users = [UserModel]()
    let cellId = "commentCell"
    var postId:String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Comment"
        tableViewOfCommets.dataSource  = self
        
        tableViewOfCommets.rowHeight = 77
        tableViewOfCommets.estimatedRowHeight = 600
        
        //  sendButton.isEnabled = false
        empty()
        handleTextField()
        loadComments()
        
        //Keyboard setup
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillhide), name: UIResponder.keyboardWillHideNotification, object: nil)
        tableViewOfCommets.keyboardDismissMode = .interactive
    }
    
    //MARK:- comment input setup with keyboard
    
    @objc func keyboardWillShow(_ notification:NSNotification)  {
        
        print(notification)
        //extract cgRectVAlue
        let keyboardFrame = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as AnyObject).cgRectValue
        
      //  print(keyboardFrame)
        UIView.animate(withDuration: 0.3) {
            self.constraintToBotton.constant = keyboardFrame!.height
            self.view.layoutIfNeeded()
        }
    }
    
    @objc func keyboardWillhide( )  {
       // print(notification)
        UIView.animate(withDuration: 0.3) {
            self.constraintToBotton.constant = 0
            self.view.layoutIfNeeded()
        }
    }
    
    //MARK:- Loading comments Data
    
    func loadComments() {
        
        Api.Post_CommentAPI.observePostComment(withPostId: postId) { (postIdFromSanpshotKey) in
            let postId = postIdFromSanpshotKey
        
            Api.CommentAPI.observComment(withPostIdFromSanpshotKeyOfObserveDataEventTypeChildAdded: postId ) { (comment) in
                
                self.fetchUser(uid: comment.uid!, completed: {
                    
                    self.comments.append(comment)
                    
                    self.tableViewOfCommets.reloadData()
                
                })
            }
        }
    }
    

    //MARK: - Fetching Data
    
    func fetchUser(uid: String, completed: @escaping () -> Void) {
        
        Api.UserAPI.observeUser(withUserId: uid) { (user) in
            self.users.append(user)
            completed()
        }
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
         tabBarController?.tabBar.isHidden = false
    }
    
    @IBAction func sendButton_TouchUpInside(_ sender: Any) {
        
       
        let commentReference = Api.CommentAPI.REF_COMMENT
        let newCommentId = commentReference.childByAutoId().key
        let newCommentReference = commentReference.child(newCommentId)
        
        guard let currentUser = Api.UserAPI.CURRENT_USER else {
            return
        }
        
        
        let words = self.commentTextField.text!.components(separatedBy: CharacterSet.whitespacesAndNewlines)
        
        for var word in words {
            if word.hasPrefix("#") {
                word = word.trimmingCharacters(in: CharacterSet.punctuationCharacters)
             
                
                let newHashTagRef = Api.hashTagAPI.REF_HASHTAG.child(word.lowercased())

                newHashTagRef.updateChildValues([self.postId + " with commentID : " +  newCommentId:true])

              

              
              
            }
        }
        
   
        newCommentReference.setValue([ "uid":currentUser.uid,
                                       "commentText":commentTextField.text!,
                                       "postId": postId
        ]) { (error, ref) in
            if error != nil {
                print("comment upload fail")
                
                return
            }
            
            
            let postCommentRef =  Api.Post_CommentAPI.REF_POST_COMMENT.child(self.postId).child(newCommentId)
            
            postCommentRef.setValue(true, withCompletionBlock: { (error, DatabaseReference) in
                if error != nil {
                    SVProgressHUD.showError(withStatus: error?.localizedDescription)
                }
            })
            
            print("comment uploaded")
            self.empty()
            self.view.endEditing(true)
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
        cell.userInCell = user
        cell.delegateOfcommentTableViewCell = self
        
        return cell
    }
    
    
    //not working with touching ??
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
        print("touchesBegan")
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "Comment_ProfileSegue" {
            let profileUserVC = segue.destination as! ProfileUserViewController
            let userId = sender as! String
            profileUserVC.userId = userId
        }
    }
}

extension commentViewController: commentTableViewCellDelegate {
    
    func goToProfileUserVC(userId: String) {
        performSegue(withIdentifier: "Comment_ProfileSegue", sender: userId)
    }
}
