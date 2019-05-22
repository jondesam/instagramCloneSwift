//
//  postApi.swift
//  instagramCloneSwift
//
//  Created by MyMac on 2019-05-19.
//  Copyright © 2019 Apex. All rights reserved.
//

import Foundation
import FirebaseDatabase

class PostApi  {
    var REF_POSTS =  Database.database().reference().child("Posts")
    
    func observePosts(completion: @escaping (Post) -> Void) {
        
        REF_POSTS.observe(.childAdded) { (snapshot: DataSnapshot) in
            
            if  let dict = snapshot.value as? [String:Any]{
                
                let newPost = Post.transFromPostPhoto(dict: dict, key: snapshot.key)
                
                completion(newPost)
            }
        }
    }
    
    
    
}
