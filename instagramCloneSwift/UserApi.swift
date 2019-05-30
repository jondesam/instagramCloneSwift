//
//  UserPai.swift
//  instagramCloneSwift
//
//  Created by MyMac on 2019-05-19.
//  Copyright © 2019 Apex. All rights reserved.
//

import Foundation
import FirebaseDatabase
import FirebaseAuth

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

    

    func observeCurrentUse(completion: @escaping(User) -> Void)  {
        
        guard let currentUser = Auth.auth().currentUser else {
            return
        }
        
        REF_USERS.child(currentUser.uid).observeSingleEvent(of: DataEventType.value) { (snapshot:DataSnapshot) in
            print("snapshot.value")
         //   print(snapshot.value)
            if  let dict = snapshot.value as? [String:Any]{
                let user = User.transformUser(dict: dict)
                completion(user)
            }
        }
    }
    
    var CURRENT_USER = Auth.auth().currentUser
    var CURRENT_USER_UID = Auth.auth().currentUser?.uid
    
    
    var REF_CURRENT_USER: DatabaseReference? {
        guard let currentUser = Auth.auth().currentUser else {
            return nil
        }
        return REF_USERS.child(currentUser.uid)
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
