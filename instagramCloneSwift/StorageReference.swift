import Foundation
import FirebaseStorage

struct StorageReference {
    static let storageRef = Storage.storage().reference(forURL: "gs://instagramcloneswift.appspot.com")
  
}
