//
//  postApi.swift
//  instagramCloneSwift
//
//  Created by MyMac on 2019-05-19.
//  Copyright © 2019 Apex. All rights reserved.
//

import Foundation
import FirebaseDatabase

class PostApi  {
    var REF_POSTS =  Database.database().reference().child("Posts")
    
    //Loading posts on homeView // replaced by feeding feature
//    func observePosts(completion: @escaping (Post) -> Void) {
//
//        REF_POSTS.observe(.childAdded) { (snapshot: DataSnapshot) in
//
//            print("////////////////////////")
//            print("snapshot of Posts node value: \(snapshot.value)")
//            print("snapshot of Posts node key: \(snapshot.key)")
//
//            if  let dict = snapshot.value as? [String:Any]{
//                let newPost = Post.transFromPostPhoto(dict: dict, key: snapshot.key)
//                completion(newPost)
//            }
//        }
//    }
    
    
    //Fetching posts that uploaded from user on <proflileView, feeding posts on homeView , DetaailView >
    //
    func observePost(withPostId id:String, completion: @escaping(Post) -> Void ) {
        
        REF_POSTS.child(id).observeSingleEvent(of: DataEventType.value) { (snapshot:DataSnapshot) in
    
//            print("////////////////////////")
//            print("snapshot of Posts.id node value: \(snapshot.value)")
//            print("snapshot of Posts.id node key: \(snapshot.key)")
            
            if  let dict = snapshot.value as? [String:Any]{
                
                let post = Post.transFromPostPhoto(dict: dict, key: snapshot.key)
                
                completion(post)
            }
        }
    }

//    func observeLikeCount(withPostId id: String, completion: @escaping (Int) -> Void){
//        Api.PostAPI.REF_POSTS.child(id).observe(.childChanged) { (snapshot) in
//            print(snapshot)
//            if let value = snapshot.value as? Int{
//                completion(value)
//            }
//        }
//
//    }
//
    
    
    // to display photos on DiscoveryView
    func obseveTopPosts(completion: @escaping(Post) -> Void){
        
        REF_POSTS.queryOrdered(byChild: "likeCount").observeSingleEvent(of: .value, with: {(snapshot) in
            
            let arraySanpshot = (snapshot.children.allObjects as! [DataSnapshot]).reversed()
            
            arraySanpshot.forEach({ (child) in
                
                if  let dict = child.value as? [String:Any]{
                    
                    let post = Post.transFromPostPhoto(dict: dict, key: child.key)
                    
                    completion(post)
                    
                }
            })
            
            ///same functionality for snippet of forEach method
//            for child in arraySanpshot {
//                if  let dict = child.value as? [String:Any]{
//                    let post = Post.transFromPostPhoto(dict: dict, key: snapshot.key)
//                    completion(post)
//                }
//            }
            
        })
    }
    
    
    //
    func removeObserveLikeCount(id:String, likeHandler:UInt){
        REF_POSTS.child(id).removeObserver(withHandle: likeHandler)
    }
    
    
    func incrementLikes(postId:String, onSuccess: @escaping (Post)->Void, onError: @escaping(_ errorMessage:String?)->Void) {
        
       let  postRef = Api.PostAPI.REF_POSTS.child(postId)
        
        postRef.runTransactionBlock({ (currentData: MutableData) -> TransactionResult in
            
            if var post = currentData.value as? [String : AnyObject],
                
                let uid = Api.UserAPI.CURRENT_USER_UID{
                
              //  print("post value 1: \(currentData.value)")
                
                var likes: Dictionary<String, Bool>
                
                likes = post["likes"] as? [String : Bool] ?? [:]
                
               // print("This is likes from snippet")
               // print(likes)
                
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
//                print(error.localizedDescription)
            }
            if let dict = snapshot?.value as? [String:Any] {
                let post = Post.transFromPostPhoto(dict: dict, key: snapshot!.key)
                onSuccess(post)
               
            }
            
           // print("post value 2: \(snapshot?.value)")
        }
    
    
    }
    
    
    
    
}
