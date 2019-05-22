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
        print("This is sanpshop.key")
        print(snapshot.key)
             let postId = snapshot.key
            completion(postId)
        }
     
    }
    
    
//    func observComment(withPostId postId:String, completion: @escaping (Comment) -> Void ) {
//
//        REF_COMMENT.child(postId).observeSingleEvent(of: DataEventType.value, with: { (snapshotComment) in
//
//            if  let dict = snapshotComment.value as? [String:Any]{
//
//                let newComment = Comment.transformComment(dict: dict)
//
//                completion(newComment)
//            }
//        })
//
//
//    }
}
