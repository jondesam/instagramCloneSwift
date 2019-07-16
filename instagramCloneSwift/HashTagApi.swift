//
//  HashTagApi.swift
//  instagramCloneSwift
//
//  Created by MyMac on 2019-07-11.
//  Copyright © 2019 Apex. All rights reserved.
//

import Foundation
import Firebase

class HashTagApi {
    
    let REF_HASHTAG = Database.database().reference().child("hashTag")
    
   
    func fetchPosts(withTag tag: String, completion: @escaping (String) -> Void )  {
        REF_HASHTAG.child(tag.lowercased()).observe(.childAdded) { (dataSnapshot) in
          
            
            var key = dataSnapshot.key
           
            var keyWithDroppedEmptySpace = key.components(separatedBy: CharacterSet.whitespaces)
            
          
            
            completion(keyWithDroppedEmptySpace[0])
            
        }
    }
    
    
}



