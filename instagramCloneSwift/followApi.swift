//
//  followApi.swift
//  instagramCloneSwift
//
//  Created by MyMac on 2019-06-02.
//  Copyright © 2019 Apex. All rights reserved.
//

import Foundation
import FirebaseDatabase

class FollowApi {
    var REF_FOLLOWERS = Database.database().reference().child("followers")
    var REF_FOLLOWING = Database.database().reference().child("following")
    
    func followedCheck(userId:String, completed: @escaping (Bool) -> Void ) {
        REF_FOLLOWERS.child(userId).child(Api.UserAPI.CURRENT_USER!.uid).observeSingleEvent(of: .value) { (snapshot) in

            if let _ = snapshot.value as? NSNull {
                completed(false)
            } else{
                completed(true)
            }

        }
    }
    
    func followingCheckForNonCurrentUser(userId:String, completed: @escaping (Bool) -> Void, completed2: @escaping (Array<String>)-> Void ) {
        REF_FOLLOWING.child(userId).observeSingleEvent(of: .value) { (snapshot) in
            print("userId from followedCheckForNonCurrentUser :\(userId)")
           // print("snapshot.value : \(snapshot.value)")
            
            if let _ = snapshot.value as? NSNull {
                completed(false)
            } else{
                completed(true)
            }
            
            var arrayOfUsers:[String] = []
            print("dataSnapshot.value : \(snapshot.value)")
            print("//////////////////////////////")
            
            if let dict =  snapshot.value as? [String: Any]{
                
                for key in dict.keys {
                    arrayOfUsers.append(key)
                }
            }
             completed2(arrayOfUsers)
            
            
            
        }
    }
    //to display if current user is followed by other users
    func followingCheck(userId:String, completed: @escaping (Bool) -> Void ) {
        REF_FOLLOWING.child(userId).child(Api.UserAPI.CURRENT_USER!.uid).observeSingleEvent(of: .value) { (snapshot) in
            
            if let _ = snapshot.value as? NSNull {
                completed(false)
            } else{
                completed(true)
            }
            
        }
        
        
    }
    
    func fetchCountFollowing(userId: String,completion: @escaping (Int)-> Void){
        REF_FOLLOWING.child(userId).observe(.value) { (snapshot) in
            let numberOfFollowing =  Int(snapshot.childrenCount)
            
            completion(numberOfFollowing)
        }
    }
    
    func fetchCountFollowers(userId: String,completion: @escaping (Int)-> Void){
        REF_FOLLOWERS.child(userId).observe(.value) { (snapshot) in
            let numberOfFollowing =  Int(snapshot.childrenCount)

            completion(numberOfFollowing)
        }
    }
    
    func removeUnfollowingUsers(userId: String, completion: @escaping (Array<String>) -> Void) {
        REF_FOLLOWERS.child(userId).observe(.value) { (dataSnapshot) in
            
            var arrayOfUsers:[String] = []
            print("dataSnapshot.value : \(dataSnapshot.value)")
            print("//////////////////////////////")
           
            if let dict =  dataSnapshot.value as? [String: Any]{
                
                for key in dict.keys {
                    arrayOfUsers.append(key)
                }
            }
            
            completion(arrayOfUsers)
            
//            if let _ = dataSnapshot.key as? NSNull {
//                completion(false)
//            } else{
//                completion(true)
//            }
            
         //   let idOfUnfollowingUsers:String
            
//            idOfUnfollowingUsers.append(dataSnapshot)
            
        }
    }
    
    
    
    func followAction(idInCell id:String){
        
        Api.MyPostsAPI.REF_MYPOSTS.child(id).observeSingleEvent(of: .value) { (snapshot) in
            if let dict = snapshot.value as? [String:Any]{
//                print("This is snapshot.value")
//                print(snapshot.value)
//                print("This is dict.keys\(dict.keys) and value \(dict.values)")
//
             //   dict.keys
                for key in dict.keys {
                    Database.database().reference().child("feed").child(Api.UserAPI.CURRENT_USER!.uid).child(key).setValue(true)
                }
            }
        }
        
        REF_FOLLOWERS.child(id).child(Api.UserAPI.CURRENT_USER!.uid).setValue(true)
        REF_FOLLOWING.child(Api.UserAPI.CURRENT_USER!.uid).child(id).setValue(true)
    }
    
    func unFollowAction(withUser id:String){
        
        Api.MyPostsAPI.REF_MYPOSTS.child(id).observeSingleEvent(of: .value) { (snapshot) in
            if let dict = snapshot.value as? [String:Any]{
                
               // dict.keys
                for key in dict.keys{
                    Database.database().reference().child("feed").child(Api.UserAPI.CURRENT_USER!.uid).child(key).removeValue()
                }
            }
        }
        
        
        REF_FOLLOWERS.child(id).child(Api.UserAPI.CURRENT_USER!.uid).setValue(NSNull())
        REF_FOLLOWING.child(Api.UserAPI.CURRENT_USER!.uid).child(id).setValue(NSNull())
    }
    

    
//    func checkFollowers(userId:String, completed: @escaping (Bool) -> Void ) {
//        REF_FOLLOWERS.child(userId).child(Api.UserAPI.CURRENT_USER!.uid).observeSingleEvent(of: .value) { (snapshot) in
//
//            if let _ = snapshot.value as? NSNull {
//                completed(false)
//            } else{
//                completed(true)
//            }
//
//        }
//    }
    
    

    
    
}
