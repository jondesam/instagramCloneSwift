import Foundation
import FirebaseDatabase
import FirebaseAuth

class UserApi {
    
    var REF_USERS =  Database.database().reference().child("users")
    
    func observeUserByUsername(username: String, completion: @escaping(UserModel) -> Void ){
        
        REF_USERS.queryOrdered(byChild: "username_lowercase").queryEqual(toValue: username).observeSingleEvent(of: .childAdded) { (dataSnapshot) in
            if let dict = dataSnapshot.value as? [String:Any] {
                
                let user = UserModel.transformUser(dictFromSnapshot: dict , key: dataSnapshot.key)
                completion(user)
            }
        }
    }
    
    
    //Fetching user information on HomeVC, ProfileVC, DetailVC, CommentVC
    func observeUser(withUserId uid:String, completion: @escaping(UserModel) -> Void ) {
        
        REF_USERS.child(uid).observeSingleEvent(of: DataEventType.value) { (snapshot:DataSnapshot) in
            
            if  let dictFromSnapshotValue = snapshot.value as? [String:Any]{
                
                let user = UserModel.transformUser(dictFromSnapshot: dictFromSnapshotValue, key: snapshot.key)
                
                completion(user)
            }
        }
    }
    
    func observeCurrentUser(completion: @escaping(UserModel) -> Void)  {
        
        guard let currentUser = Auth.auth().currentUser else {
            return
        }
        
        REF_USERS.child(currentUser.uid).observeSingleEvent(of: DataEventType.value) { (snapshot:DataSnapshot) in
            
            if  let dictFromSnapshotValue = snapshot.value as? [String:Any]{
                
                let user = UserModel.transformUser(dictFromSnapshot: dictFromSnapshotValue, key: snapshot.key)
                completion(user)
            }
        }
    }
    
    
    //Fetching users on peopleView for Current User
    func observeUsers(completion:@escaping(UserModel) -> Void){
        REF_USERS.observe(.childAdded) { (snapshot) in
            if  let dictFromSnapshotValue = snapshot.value as? [String:Any]{
                
                let user = UserModel.transformUser(dictFromSnapshot: dictFromSnapshotValue, key: snapshot.key)
                
                //removing current user on peopleView
                if user.id != Api.UserAPI.CURRENT_USER?.uid {
                    
                    completion(user)
                }
            }
        }
    }
    
    
    func observeUsersForNonCurrentUsers(completion:@escaping(UserModel) -> Void){
        REF_USERS.observe(.childAdded) { (snapshot) in
            if  let dictFromSnapshotValue = snapshot.value as? [String:Any]{
                
                let user = UserModel.transformUser(dictFromSnapshot: dictFromSnapshotValue, key: snapshot.key)
                
                completion(user)
                
            }
        }
    }
    
    
    func querryUsers(withText text: String, completion:@escaping(UserModel) -> Void ){
        REF_USERS.queryOrdered(byChild: "username_lowercase").queryStarting(atValue: text).queryEnding(atValue: text+"\u{f8ff}").queryLimited(toFirst: 10).observeSingleEvent(of: .value, with: { snapshot in
            
            for s in snapshot.children {
                let child = s as! DataSnapshot
                
                if let dictFromSnapshotChildValue = child.value as? [String:Any]{
                    let user = UserModel.transformUser(dictFromSnapshot: dictFromSnapshotChildValue, key: child.key)
                    
                    if user.id! != Api.UserAPI.CURRENT_USER?.uid {//removing current user on peopleView
                        completion(user)
                    }
                }
            }
        })
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
