import Foundation
import FirebaseDatabase


class CommentApi {
    
    let REF_COMMENT = Database.database().reference().child("comments")
    
    func observComment(withPostIdFromSanpshotKeyOfObserveDataEventTypeChildAdded postId: String, completion: @escaping (Comment) -> Void ) {
        
        REF_COMMENT.child(postId).observeSingleEvent(of: DataEventType.value, with: { (snapshotComment) in
            
            if  let dict = snapshotComment.value as? [String:Any]{
                
                let newComment = Comment.transformComment(dict: dict)
                
                completion(newComment)
            }
        })
    }
}



