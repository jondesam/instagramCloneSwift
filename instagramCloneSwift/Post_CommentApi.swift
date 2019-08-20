import Foundation
import FirebaseDatabase

class Post_CommentApi {
    var REF_POST_COMMENT = Database.database().reference().child("post-comments")
    
    func observePostComment(withPostId postId:String, completion: @escaping(String) -> Void) {
       REF_POST_COMMENT.child(postId).observe(DataEventType.childAdded) { (snapshot) in

        let postId = snapshot.key
            completion(postId)
        }
     
    }
}
