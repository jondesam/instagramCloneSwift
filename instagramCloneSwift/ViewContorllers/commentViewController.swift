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

class commentViewController: UIViewController {

    @IBOutlet weak var commentTextField: UITextField!
    @IBOutlet weak var sendButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
      //  sendButton.isEnabled = false
        empty()
        handleTextField()
     
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

}
