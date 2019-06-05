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
    
    func followAction(idInCell id:String){
        REF_FOLLOWERS.child(id).child(Api.UserAPI.CURRENT_USER!.uid).setValue(true)
        REF_FOLLOWING.child(Api.UserAPI.CURRENT_USER!.uid).child(id).setValue(true)
    }
    
    func unFollowAction(withUser id:String){
        REF_FOLLOWERS.child(id).child(Api.UserAPI.CURRENT_USER!.uid).setValue(NSNull())
        REF_FOLLOWING.child(Api.UserAPI.CURRENT_USER!.uid).child(id).setValue(NSNull())
    }
    
    func isFollowing(userId:String, completed: @escaping (Bool) -> Void ) {
        REF_FOLLOWERS.child(userId).child(Api.UserAPI.CURRENT_USER!.uid).observeSingleEvent(of: .value) { (snapshot) in
            
            if let _ = snapshot.value as? NSNull {
                completed(false)
            } else{
                completed(true)
            }
            
        }
    }
}
