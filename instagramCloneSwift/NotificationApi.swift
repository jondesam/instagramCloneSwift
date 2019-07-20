//
//  NotificationApi.swift
//  instagramCloneSwift
//
//  Created by MyMac on 2019-07-18.
//  Copyright © 2019 Apex. All rights reserved.
//

import Foundation
import FirebaseDatabase

class NotificationApi  {
    
    let REF_NOTIFICATION = Database.database().reference().child("notification")
    
    func observeNotification(with id:String, completion:@escaping(Notification) -> Void) {
        
        REF_NOTIFICATION.child(id).observe(.childAdded) { (dataSnapshot) in
            
            if let dict = dataSnapshot.value as? [String:Any] {
                
                let newNoti = Notification.transform(dict: dict, key: dataSnapshot.key)
                
                completion(newNoti)
            }
        }
    }

}


