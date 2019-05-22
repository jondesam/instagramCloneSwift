//
//  UserPai.swift
//  instagramCloneSwift
//
//  Created by MyMac on 2019-05-19.
//  Copyright © 2019 Apex. All rights reserved.
//

import Foundation
import FirebaseDatabase

class UserApi {
    var REF_USERS =  Database.database().reference().child("users")
    
    func observeUsers(withId uid:String, completion: @escaping(User) -> Void ) {
        
       REF_USERS.child(uid).observeSingleEvent(of: DataEventType.value) { (snapshot:DataSnapshot) in
        
        if  let dict = snapshot.value as? [String:Any]{
            let user = User.transformUser(dict: dict)
            completion(user)
            }
        }
    }
    
//    func observeUsersMal(uid:String, completion: @escaping(User) -> Void ) {
//
//        REF_USERS.child(uid).observeSingleEvent(of: DataEventType.value) { (snapshot:DataSnapshot) in
//
//            if  let dict = snapshot.value as? [String:Any]{
//                let user = User.transformUser(dict: dict)
//                completion(user)
//            }
//        }
//    }
    
}
