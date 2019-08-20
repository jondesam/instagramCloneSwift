import Foundation

class UserModel {
    var email: String?
    var profileImageUrl: String?
    var username: String?
    var id: String?
    var isFollowed:Bool?
    var bio:String?
    
    static func transformUser(dictFromSnapshot: [String:Any], key: String) -> UserModel {
        
        let user = UserModel()
        
        user.email = dictFromSnapshot["email"] as? String
        user.profileImageUrl = dictFromSnapshot["profileImageUrl"] as? String
        user.username = dictFromSnapshot["username"] as? String
        user.bio = dictFromSnapshot["bio"] as? String
        user.id = key
        
        return user
        
    }
    
    static func transFromPostVideo() {
        
    }
}

