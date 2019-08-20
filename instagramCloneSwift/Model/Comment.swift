import Foundation

class Comment {
    var commentText: String?
    var uid: String?
    
    static func transformComment(dict: [String:Any]) -> Comment {
        let comment = Comment()
        
        comment.commentText = dict["commentText"] as? String
        comment.uid = dict["uid"] as? String
        
        return comment
    }
}
