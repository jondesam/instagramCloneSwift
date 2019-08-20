import Foundation
import FirebaseAuth
class Notification {

    var from: String?
    var postId : String?
    var type: String?
    var timestamp: Int?
    var id: String?
    
}

extension Notification {
    static func transform(dict: [String:Any], key:String) -> Notification {
        
        let notification = Notification()
        
        notification.id = key
        notification.postId = dict["postId"] as? String
        notification.from = dict["from"] as? String
        notification.type = dict["type"] as? String
        notification.timestamp = dict["timestamp"] as? Int
        
        return notification

    }
}
    

