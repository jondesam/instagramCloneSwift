import Foundation
import Firebase

class HashTagApi {
    
    let REF_HASHTAG = Database.database().reference().child("hashTag")
    
    func fetchPosts(withTag tag: String, completion: @escaping (String) -> Void )  {
        REF_HASHTAG.child(tag.lowercased()).observe(.childAdded) { (dataSnapshot) in
          
            let key = dataSnapshot.key
           
            var keyWithDroppedEmptySpace = key.components(separatedBy: CharacterSet.whitespaces)
        
            completion(keyWithDroppedEmptySpace[0])
        }
    }
}



