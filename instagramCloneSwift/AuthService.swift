import Foundation
import FirebaseAuth
import SVProgressHUD
import FirebaseDatabase

class AuthService {
    
    static func signIn(email: String, password: String, onSuccess: @escaping () ->Void, onError:@escaping () ->Void) {
        Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
            
            if error != nil {
                onError()
                
                SVProgressHUD.dismiss()
            } else {
                SVProgressHUD.setMinimumDismissTimeInterval(1.0)
                SVProgressHUD.showSuccess(withStatus: "Sign Up Success")
                onSuccess()
            }
        }
    }
    
    
    static func signUp(email: String,id: String, password: String, onSuccess: @escaping () ->Void, onError:@escaping () ->Void) {
        Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
            if error != nil {
                onError()
                return
            }
            
            let uid = user?.uid
            let ref = Database.database().reference()
            let userReference = ref.child("users")
            let newUserReference = userReference.child(uid!)
            
            newUserReference.setValue(["username": id,
                                       "username_lowercase": id.lowercased(),
                                       "email": email])
            
            SVProgressHUD.setMinimumDismissTimeInterval(1.0)
            SVProgressHUD.showSuccess(withStatus: "Sign Up Success")
            onSuccess()
            
            return
        }
    }
    
    static func logOut(onSuccess: @escaping () ->Void, onError:@escaping (_ logOutError:String) ->Void){
        
        do {
            try  Auth.auth().signOut()
            onSuccess()
        } catch let logOutError {
            onError(logOutError.localizedDescription)
        }
    }
    
    
    static  func updateUserInfo(username:String, imageData:Data, bio:String , onSuccess:@escaping() -> Void, onEror: @escaping (_ errorMessage:String?) -> Void ){
        
        let currentUser = Api.UserAPI.CURRENT_USER
        let storageRef = StorageReference.storageRef
        let profileImageRef = storageRef.child("profile_photo").child((currentUser?.email)!)
        
        profileImageRef.putData(imageData, metadata: nil) { (storageMetadata, error) in
            if error != nil {
                return
            }
            
            profileImageRef.downloadURL(completion: { (url, error) in
                
                if error != nil {
                    return
                }else {
                    let profilePhotoUrl  = url?.absoluteString
                    
                    updateDatabase(profileImageUrl: profilePhotoUrl!, id: username, bio: bio, onSuccess: onSuccess, onEror: onEror)
                    
                }
            })
        }
    }
    
    static func updateDatabase(profileImageUrl:String, id:String, bio: String, onSuccess:@escaping() -> Void, onEror: @escaping (_ errorMessage:String?) -> Void ){
        
        let dict = ["username": id,
                    "username_lowercase": id.lowercased(),
                    "profileImageUrl": profileImageUrl,
                    "bio":bio.lowercased()]
        
        Api.UserAPI.REF_CURRENT_USER?.updateChildValues(dict, withCompletionBlock: { (error, databaseReference) in
            
            if error != nil {
                SVProgressHUD.showError(withStatus: error?.localizedDescription)
            } else {
                onSuccess()
                SVProgressHUD.showSuccess(withStatus: "Success")
            }
        })
    }
}



