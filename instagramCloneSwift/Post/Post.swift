//
//  File.swift
//  instagramCloneSwift
//
//  Created by MyMac on 2019-05-07.
//  Copyright © 2019 Apex. All rights reserved.
//

import Foundation
import FirebaseAuth

class Post {
    var description :String?
    var photoURL :String?
    var user:String?
    var uid: String?
    var id: String?
    
    var likeCount:Int?
    var likes: Dictionary<String, Any>?
    var isLiked: Bool?
    
    static func transFromPostPhoto(dict: [String:Any], key:String) -> Post {
        
        let post  = Post()
        
        post.description = dict["description"] as? String
        post.photoURL = dict["photoUrl"] as? String
        post.user = dict["user"] as? String
        post.uid = dict["uid"] as? String
        post.id = key
       // print("key")
        //print(key)
        post.likeCount = dict["likeCount"] as? Int
        
        //reason for Dict<String,Any>
        //Firebase delete likes nod when there is no "like"
        //thus, to have true(1) and nil
        post.likes = dict["likes"] as? Dictionary<String,Any>
        
        //Set up isLiked depends on "likes" or not
        if let currentUserId = Auth.auth().currentUser?.uid{
           // print("currentUserId")
            //print(currentUserId)
            
            //Alternative//
            //             if post.likes != nil {
            //            post.isLiked = post.likes![currentUserId] != nil
            //                }
            
            if post.likes != nil {
                
                if post.likes![currentUserId] != nil {
                    
               //     print("this is post.likes")
                //    print(post.likes)
                    
                    post.isLiked = true
                } else {
                    post.isLiked = false
                }
            }
        }
      //  print("This is post form post Model")
      //  dump(post)
        return post
    }
    
    
    
    static func transFromPostVideo() {
        
    }
    
    
}
