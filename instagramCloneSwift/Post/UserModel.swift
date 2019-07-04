//
//  User.swift
//  instagramCloneSwift
//
//  Created by MyMac on 2019-05-10.
//  Copyright © 2019 Apex. All rights reserved.
//

import Foundation

class UserModel {
    var email: String?
    var profileImageUrl: String?
    var username: String?
    var id: String?
    var isFollowed:Bool?
    
    static func transformUser(dictFromSnapshot: [String:Any], key: String) -> UserModel {
        
        let user = UserModel()
        
        user.email = dictFromSnapshot["email"] as? String
        user.profileImageUrl = dictFromSnapshot["profileImageUrl"] as? String
        user.username = dictFromSnapshot["username"] as? String
        user.id = key
        
        return user
        
    }
    
    static func transFromPostVideo() {
        
    }
    
    
}

