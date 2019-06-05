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
    
    static func transformUser(dict: [String:Any], key: String) -> UserModel {
        let user = UserModel()
        
        user.email = dict["email"] as? String
        user.profileImageUrl = dict["profileImageUrl"] as? String
        user.username = dict["username"] as? String
        user.id = key
        
        return user
        
    }
    
    static func transFromPostVideo() {
        
    }
    
    
}

