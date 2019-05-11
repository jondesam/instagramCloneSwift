//
//  File.swift
//  instagramCloneSwift
//
//  Created by MyMac on 2019-05-07.
//  Copyright © 2019 Apex. All rights reserved.
//

import Foundation
class Post {
    var description :String?
    var photoURL :String?
    var user:String?
    var uid: String?
    
    //temp init
//    init(descriptionText: String, photoUrlString: String, userString: String) {
//        description = descriptionText
//        photoURL = photoUrlString
//        user = userString
//    }
    
   static func transFromPostPhoto(dict: [String:Any]) -> Post {
        let post  = Post()
        
        post.description = dict["description"] as? String
        post.photoURL = dict["photoUrl"] as? String
        post.user = dict["user"] as? String
        post.uid = dict["uid"] as? String
        return post
    }
    
    static func transFromPostVideo() {
        
    }
    
    
}
