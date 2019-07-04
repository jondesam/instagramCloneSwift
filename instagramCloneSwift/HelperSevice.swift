//
//  HelperSevice.swift
//  instagramCloneSwift
//
//  Created by MyMac on 2019-05-29.
//  Copyright © 2019 Apex. All rights reserved.
//

import Foundation
import SVProgressHUD

class HelperService {
    
    static func uploadDataToServer(imageData: Data, videoUrl:URL? = nil , description:String, onSuccess: @escaping ()->Void, onError: @escaping () -> Void ) {
        
        if let videoUrl = videoUrl {
        
            UploadVideoToStorage(videoUrl) { (videoUrl) in
            
                //uploading thumbnail photo
                uploadImageToStorage(imageData, onSuccess: { (thumbnailImageUrl) in
                //photoUrl will be thumbnailImageUrl
                    sendDataToDatabase(photoUrl:thumbnailImageUrl ,videoUrl: videoUrl, description: description, onSuccess: onSuccess, onError: onError)
                })
            }
        } else {
            uploadImageToStorage(imageData) { (photoUrl) in
                
                self.sendDataToDatabase(photoUrl: photoUrl, description: description, onSuccess: onSuccess, onError: onError)
            }
        }
    }
    
    //in the case of Video
    
    static  func UploadVideoToStorage(_ videoUrl:URL, onSuccess: @escaping (_ videoUrl: String)-> Void) {
        
        let user = Api.UserAPI.CURRENT_USER
        let videoIdString =  UUID().uuidString
        let storageRef =  StorageReference.storageRef
        //  storageRef = gs://instagramcloneswift.appspot.com/sharing_photo
        
        let sharingImageRef = storageRef.child("sharing_photo").child(user!.email!).child(videoIdString)
        
        sharingImageRef.putFile(from: videoUrl, metadata: nil) { (metadata, error) in
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
                        let sharingVideoUrl = url?.absoluteString
                        onSuccess(sharingVideoUrl!)
                        // self.sendDataToDatabase(photoUrl: SharingPhotoUrl!, description: description, onSuccess: onSuccess, onError: onError)
                    }
                })
                
                // SVProgressHUD.showSuccess(withStatus: "Upload Success")
                
                return
                
            }
        }
    }
    
    
    
    //in case of Image
    static  func uploadImageToStorage(_ imageData: Data, onSuccess: @escaping (_ imageUrl: String)-> Void ) {
        
        let user = Api.UserAPI.CURRENT_USER
        let photoIdString =  UUID().uuidString
        let storageRef =  StorageReference.storageRef
        //gs://instagramcloneswift.appspot.com/sharing_photo
        
        let sharingImageRef = storageRef.child("sharing_photo").child(user!.email!).child(photoIdString)
        
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
                        let sharingPhotoUrl = url?.absoluteString
                        onSuccess(sharingPhotoUrl!)
                        // self.sendDataToDatabase(photoUrl: SharingPhotoUrl!, description: description, onSuccess: onSuccess, onError: onError)
                    }
                })
                
                // SVProgressHUD.showSuccess(withStatus: "Upload Success")
                
                return
            }
        }
        
    }
    

    
    
    static func sendDataToDatabase(photoUrl:String,videoUrl: String? = nil, description: String, onSuccess: @escaping ()-> Void, onError: @escaping () -> Void ){
        
        let newPostId = Api.PostAPI.REF_POSTS.childByAutoId().key
        let newPostReference = Api.PostAPI.REF_POSTS.child(newPostId)
        
        guard let currentUser = Api.UserAPI.CURRENT_USER else {
            return
        }
        
        var dict = ["photoUrl":photoUrl, "description":description, "user": currentUser.email!, "uid":currentUser.uid, "likeCount": 0] as [String : Any]
        
        if let videoUrl = videoUrl {
            dict["videoUrl"] = videoUrl
        }
        
        newPostReference.setValue(dict) { (error, ref) in
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
