//
//  Post_Comment.swift
//  instagramCloneSwift
//
//  Created by MyMac on 2019-05-20.
//  Copyright © 2019 Apex. All rights reserved.
//

import Foundation
import FirebaseDatabase

class Post_CommentApi {
    var REF_POST_COMMENT = Database.database().reference().child("post-comments")
    
    func observePostComment(withPostId postId:String, completion: @escaping(String) -> Void) {
       REF_POST_COMMENT.child(postId).observe(DataEventType.childAdded) { (snapshot) in
        
     //   print("This is sanpshop.key")
     //   print(snapshot.key)
        
        let postId = snapshot.key
            completion(postId)
        }
     
    }
    
    

}
