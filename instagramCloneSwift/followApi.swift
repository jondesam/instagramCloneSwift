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
            
            if let _ = snapshot.value as? NSNull {
                completed(false)
            } else{
                completed(true)
            }
            
            var arrayOfUsers:[String] = []
            
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
            
            if let dict =  dataSnapshot.value as? [String: Any]{
                
                for key in dict.keys {
                    arrayOfUsers.append(key)
                }
            }
            
            completion(arrayOfUsers)
            
        }
    }
    
    
    func followAction(idInCell id:String){
        
        Api.MyPostsAPI.REF_MYPOSTS.child(id).observeSingleEvent(of: .value) { (snapshot) in
            if let dict = snapshot.value as? [String:Any]{
                
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
                
                for key in dict.keys{
                    Database.database().reference().child("feed").child(Api.UserAPI.CURRENT_USER!.uid).child(key).removeValue()
                }
            }
        }
        
        
        REF_FOLLOWERS.child(id).child(Api.UserAPI.CURRENT_USER!.uid).setValue(NSNull())
        REF_FOLLOWING.child(Api.UserAPI.CURRENT_USER!.uid).child(id).setValue(NSNull())
    }
    
}
