import Foundation
import SVProgressHUD
import FirebaseDatabase

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
                    }
                })
                return
            }
        }
    }
    
    //in case of Image
    static  func uploadImageToStorage(_ imageData: Data, onSuccess: @escaping (_ imageUrl: String)-> Void ) {
        
        let user = Api.UserAPI.CURRENT_USER
        let photoIdString =  UUID().uuidString
        let storageRef =  StorageReference.storageRef
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
                        
                    }
                })
                
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
        
        let words = description.components(separatedBy: CharacterSet.whitespacesAndNewlines)
        
        for var word in words {
            if word.hasPrefix("#") {
                word = word.trimmingCharacters(in: CharacterSet.punctuationCharacters)
                
                let newHashTagRef = Api.HashTagAPI.REF_HASHTAG.child(word.lowercased())
                
                newHashTagRef.updateChildValues([newPostId:true])
            }
        }
        
        let timestamp = Int(Date().timeIntervalSince1970)
        
        var dict = ["photoUrl":photoUrl, "description":description, "user": currentUser.email!, "uid":currentUser.uid, "likeCount": 0, "timestamp":timestamp] as [String : Any]
        
        if let videoUrl = videoUrl {
            dict["videoUrl"] = videoUrl
        }
        
        newPostReference.setValue(dict) { (error, ref) in
            if error != nil {
                onError()
                SVProgressHUD.showError(withStatus: error?.localizedDescription)
                return
            }
            
            Api.FeedAPI.REF_FEED.child(Api.UserAPI.CURRENT_USER!.uid).child(newPostId).setValue(true)//to make feed node
            
            
            //MARK: - Notification upload in Firebase
            
            Api.FollowAPI.REF_FOLLOWERS.child(Api.UserAPI.CURRENT_USER!.uid).observeSingleEvent(of: .value, with: { (dataSnapshot) in
                
                let arraySnapshot = dataSnapshot.children.allObjects as! [DataSnapshot]
                
                arraySnapshot.forEach({ (snapshot) in
                    
                    Api.FeedAPI.REF_FEED.child(snapshot.key).updateChildValues(["\(newPostId)" : true])// to feed followers
                    
                    let newNotificationId = Api.Norification.REF_NOTIFICATION.child(snapshot.key) .childByAutoId().key
                    
                    let newNotificationReference = Api.Norification.REF_NOTIFICATION.child(snapshot.key).child(newNotificationId)
                    
                    newNotificationReference.setValue(["from": Api.UserAPI.CURRENT_USER!.uid,
                                                       "type": "feed",
                                                       "postId": newPostId,
                                                       "timestamp":timestamp])
                })
            })
            
            let myPostRef = Api.MyPostsAPI.REF_MYPOSTS.child(currentUser.uid).child(newPostId)
            
            myPostRef.setValue(true, withCompletionBlock: { (error, ref) in
                if error != nil {
                    SVProgressHUD.showError(withStatus: error?.localizedDescription)
                    return
                }
            })
            
            SVProgressHUD.showSuccess(withStatus: "Success")
            onSuccess()
        }
    }
}
