//
//  MyPostsApi.swift
//  instagramCloneSwift
//
//  Created by MyMac on 2019-05-27.
//  Copyright © 2019 Apex. All rights reserved.
//

import Foundation
import FirebaseDatabase

class MyPostsApi {
    var REF_MYPOSTS = Database.database().reference().child("myPosts")
    
    func fetchMyPosts(currentUser: String, completion: @escaping (String)-> Void) {
        
        REF_MYPOSTS.child(currentUser).observe(.childAdded) { (snapshot) in
            completion(snapshot.key)
        }
    }
    
    func fetchCountMyPosts(userId: String, completion: @escaping (Int)-> Void) {
        
        REF_MYPOSTS.child(userId).observe(.value) { (snapshot) in
            let numberOfMyPost =  Int(snapshot.childrenCount)
            
            completion(numberOfMyPost)
        }
        
    }
    
    
    
}
