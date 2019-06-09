

    import Foundation
    import FirebaseAuth
    import SVProgressHUD
    import FirebaseDatabase


    class AuthService {
      
        static func signIn(email: String, password: String, onSuccess: @escaping () ->Void, onError:@escaping () ->Void) {
            Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
                
                if error != nil {
                    onError()
                   
                    print(error!.localizedDescription)
                    SVProgressHUD.dismiss()
                } else {
                    print("Log in successful!")
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
                    
                    print(error!.localizedDescription)
                    
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
               
                // SVProgressHUD.dismiss()
                return
            }
        }
        
        static func logOut(onSuccess: @escaping () ->Void, onError:@escaping (_ logOutError:String) ->Void){
        
            do {
                try  Auth.auth().signOut()
                onSuccess()
            } catch let logOutError {
                print(logOutError)
                onError(logOutError.localizedDescription)
            }
        
        
        }

        
        
    }


