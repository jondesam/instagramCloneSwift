import Foundation
import FirebaseAuth

class Post {
    
    var description :String?
    var photoUrl :String?
    var videoUrl :String?
    var user:String?
    var uid: String?
    var id: String?
    var likeCount:Int?
    var likes: Dictionary<String, Any>?
    var isLiked: Bool?
    var timeStamp: Int?
    
    static func transFromPostPhoto(dictFromSnapshot: [String:Any], key:String) -> Post {
        
        let post  = Post()
        
        post.videoUrl = dictFromSnapshot["videoUrl"] as? String
        post.description = dictFromSnapshot["description"] as? String
        post.photoUrl = dictFromSnapshot["photoUrl"] as? String
        post.user = dictFromSnapshot["user"] as? String
        post.uid = dictFromSnapshot["uid"] as? String
        post.timeStamp = dictFromSnapshot["timestamp"] as? Int 
        post.id = key
        post.likeCount = dictFromSnapshot["likeCount"] as? Int
        
        //reason for Dict<String,Any>
        //Firebase delete likes nod when there is no "like"
        //thus, to have true(1) and nil
        post.likes = dictFromSnapshot["likes"] as? Dictionary<String,Any>
        
        //Set up isLiked depends on "likes" or not
        if let currentUserId = Auth.auth().currentUser?.uid{
        
            if post.likes != nil {
                
                if post.likes![currentUserId] != nil {
     
                    post.isLiked = true
                } else {
                    post.isLiked = false
                }
            }
        }

        return post
    }
    
    static func transFromPostVideo() {
        
    }
}
