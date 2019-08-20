import Foundation
import FirebaseDatabase

class PostApi  {
    var REF_POSTS =  Database.database().reference().child("Posts")

    func observePost(withPostId id:String, completion: @escaping(Post) -> Void ) {
        
        REF_POSTS.child(id).observeSingleEvent(of: DataEventType.value) { (snapshot:DataSnapshot) in

            if  let dictFromSnapshotValue = snapshot.value as? [String:Any]{
                
                let post = Post.transFromPostPhoto(dictFromSnapshot: dictFromSnapshotValue, key: snapshot.key)
                
                completion(post)
            }
        }
    }
    
    
    // to display photos on DiscoveryView
    func obseveTopPosts(completion: @escaping(Post) -> Void){
        
        REF_POSTS.queryOrdered(byChild: "likeCount").observeSingleEvent(of: .value, with: {(snapshot) in
            
            let arraySanpshot = (snapshot.children.allObjects as! [DataSnapshot]).reversed()
            
            arraySanpshot.forEach({ (child) in
                
                if  let dictFromSnapshotChildValue = child.value as? [String:Any]{
                    
                    let post = Post.transFromPostPhoto(dictFromSnapshot: dictFromSnapshotChildValue, key: child.key)
                    
                    completion(post)
                }
            })
        })
    }
    
    

    func removeObserveLikeCount(id:String, likeHandler:UInt){
        REF_POSTS.child(id).removeObserver(withHandle: likeHandler)
    }
    
    
    func incrementLikes(postId:String, onSuccess: @escaping (Post)->Void, onError: @escaping(_ errorMessage:String?)->Void) {
        
       let  postRef = Api.PostAPI.REF_POSTS.child(postId)
        
        postRef.runTransactionBlock({ (currentData: MutableData) -> TransactionResult in
            
            if var post = currentData.value as? [String : AnyObject],
                
                let uid = Api.UserAPI.CURRENT_USER_UID{
                
                var likes: Dictionary<String, Bool>
                
                likes = post["likes"] as? [String : Bool] ?? [:]
                
                var likeCount = post["likeCount"] as? Int ?? 0
                
                if let _ = likes[uid] {
                // Unstar the post and remove self from stars
                    likeCount -= 1
                    
                    likes.removeValue(forKey: uid)
                    
                } else {
                // Star the post and add self to stars
                    likeCount += 1
                    
                    likes[uid] = true
                    
                }
                
                post["likeCount"] = likeCount as AnyObject?
                post["likes"] = likes as AnyObject?
                
                // Set value and report transaction success
                currentData.value = post
                
                return TransactionResult.success(withValue: currentData)
            }
            
            return TransactionResult.success(withValue: currentData)
        }) { (error, committed, snapshot) in
            if let error = error {
                onError(error.localizedDescription)
            }
            if let dictFromSnapshotValue = snapshot?.value as? [String:Any] {
               
                let post = Post.transFromPostPhoto(dictFromSnapshot: dictFromSnapshotValue, key: snapshot!.key)
                onSuccess(post)
               
            }
        }
    }
}
