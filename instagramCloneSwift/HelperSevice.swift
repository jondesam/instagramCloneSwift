//
//  HelperSevice.swift
//  instagramCloneSwift
//
//  Created by MyMac on 2019-05-29.
//  Copyright © 2019 Apex. All rights reserved.
//

import Foundation
import FirebaseStorage
import SVProgressHUD

class HelperService {
    
    static func uploadDataToServer(imageData: Data, description:String, onSuccess: @escaping ()->Void, onError: @escaping () -> Void ) {
        
        let user = Api.UserAPI.CURRENT_USER
        
        let uuid =  UUID().uuidString
        let storageRef = Storage.storage().reference(forURL: Config.STORAGE_ROOF_REF)
        
        let sharingImageRef = storageRef.child("sharing_photo").child(user!.email!).child(uuid)
        
        sharingImageRef.putData(imageData, metadata: nil) { (metadata, error) in
            if error != nil {
                print(error!)
                
                return
            } else {
                
                //downloading Sharing Image Url
                sharingImageRef.downloadURL(completion: { (url, error) in
                    if error != nil {
                        print("Download URL fail")
                        return
                    }else {
                        let SharingPhotoUrl = url?.absoluteString
                        
                        self.sendDataToDatabase(photoUrl: SharingPhotoUrl!, description: description, onSuccess: onSuccess, onError: onError
                            
                        )
                    }
                })
                
                // SVProgressHUD.showSuccess(withStatus: "Upload Success")
                
                return
            }
        }
    }
    
    
    static func sendDataToDatabase(photoUrl:String, description: String, onSuccess: @escaping ()-> Void, onError: @escaping () -> Void ){
        
        let newPostId = Api.PostAPI.REF_POSTS.childByAutoId().key
        let newPostReference = Api.PostAPI.REF_POSTS.child(newPostId)
        
        guard let currentUser = Api.UserAPI.CURRENT_USER else {
            return
        }
        
        newPostReference.setValue(["photoUrl":photoUrl,
                                   "description":description,
                                   "user": currentUser.email,
                                   "uid":currentUser.uid,
                                   "likeCount": 0]) { (error, ref) in
                                    if error != nil {
                                        print("data upload fail")
                                        onError()
                                        SVProgressHUD.showError(withStatus: error?.localizedDescription)
                                        return
                                    }
                                    Api.FeedAPI.REF_FEED.child(Api.UserAPI.CURRENT_USER!.uid).child(newPostId).setValue(true)
                                    
                                    let myPostRef = Api.MyPostsAPI.REF_MYPOSTS.child(currentUser.uid).child(newPostId)
                                    
                                    myPostRef.setValue(true, withCompletionBlock: { (error, ref) in
                                        if error != nil {
                                        SVProgressHUD.showError(withStatus: error?.localizedDescription)
                                            return
                                        }
                                    })
                                    
                                    print("data uploaded")
                                    SVProgressHUD.showSuccess(withStatus: "Success")
                                    onSuccess()
        }
    }
}
