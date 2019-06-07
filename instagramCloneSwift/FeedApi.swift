//
//  FeedApi.swift
//  instagramCloneSwift
//
//  Created by MyMac on 2019-06-06.
//  Copyright © 2019 Apex. All rights reserved.
//

import Foundation
import FirebaseDatabase

class FeedApi {
    
    var REF_FEED = Database.database().reference().child("feed")
    
    func observeFeed(withUserId id: String, completion:@escaping (Post) -> Void) {
        REF_FEED.child(id).observe(.childAdded) { (snapshot) in
            let key = snapshot.key
            
            Api.PostAPI.observePost(withPostId: key, completion: { (post) in
                completion(post)
            })
        }
    }
    
    func observeFeedRemoved(withUserId id: String, completion: @escaping (Post)-> Void){
        REF_FEED.child(id).observe(.childRemoved) { (snapshot) in
            let key = snapshot.key
            
            Api.PostAPI.observePost(withPostId: key, completion: { (post) in
                 completion(post)
            })
          
        }
    }
    
}
