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
    
    func observeUser(withUserId uid:String, completion: @escaping(UserModel) -> Void ) {

       REF_USERS.child(uid).observeSingleEvent(of: DataEventType.value) { (snapshot:DataSnapshot) in
            dump("This is snapshot.value of observeUser \(snapshot.value)")
        
        if  let dict = snapshot.value as? [String:Any]{
            
            let user = UserModel.transformUser(dict: dict, key: snapshot.key)
            
            dump("This is user \(user.email)")
            
            completion(user)
            }
        }
    }

    func observeCurrentUse(completion: @escaping(UserModel) -> Void)  {
        
        guard let currentUser = Auth.auth().currentUser else {
            return
        }
        
        REF_USERS.child(currentUser.uid).observeSingleEvent(of: DataEventType.value) { (snapshot:DataSnapshot) in
            
           // print("snapshot.value")
           // print(snapshot.value)
            
            if  let dict = snapshot.value as? [String:Any]{
                let user = UserModel.transformUser(dict: dict, key: snapshot.key)
                completion(user)
            }
        }
    }
    
    func observeUsers(completion:@escaping(UserModel) -> Void){
        REF_USERS.observe(.childAdded) { (snapshot) in
            if  let dict = snapshot.value as? [String:Any]{
                let user = UserModel.transformUser(dict: dict, key: snapshot.key)
                completion(user)
            }
        }
    }
    
    
    
    //Firebase User type was confused with custom type User.
    //currently class: User -> UserModel
    var CURRENT_USER: User? {
        guard let currentUser = Auth.auth().currentUser else {
            return nil
        }
        return currentUser
    }

    
    var CURRENT_USER_UID = Auth.auth().currentUser?.uid
    
    
    var REF_CURRENT_USER: DatabaseReference? {
        guard let currentUser = Auth.auth().currentUser else {
            return nil
        }
        return REF_USERS.child(currentUser.uid)
    }
    

    
}
