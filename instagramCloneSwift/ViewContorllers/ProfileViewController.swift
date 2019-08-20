import UIKit
import SVProgressHUD

class ProfileViewController: UIViewController, UINavigationControllerDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    let storageRef = StorageReference.storageRef
    var user: UserModel!
    var posts: [Post] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.dataSource = self
        collectionView.delegate = self
        fetchUser()
        fectchMyPosts()
        
    }
    
    //MARK: fetching User info
    func fetchUser() {
        Api.UserAPI.observeCurrentUser { (user) in
            
            self.user = user
            self.navigationItem.title = user.username
            self.collectionView.reloadData()
        }
    }
    
    
    //MARK: fecthincg Posts
    func fectchMyPosts() {
        //naming error used to occur ->user's photo can not be dicerned
        //Firebase User type was confused with custom type User.
        //currently class: User -> UserModel
        guard let currentUser = Api.UserAPI.CURRENT_USER else {
            return
        }
        
        Api.MyPostsAPI.fetchMyPosts(currentUser: currentUser.uid) { (key) in
            Api.PostAPI.observePost(withPostId: key, completion: { (post) in
                self.posts.append(post)
                self.collectionView.reloadData()
            })
        }
    }
    
    //MARK: - CollectionView Methods
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCollectionViewCell" , for: indexPath) as! PhotoCollectionViewCell
        
        let post = posts.reversed()[indexPath.row]
        cell.post = post
        cell.delegateOfPhotoCollectionViewCell = self
        
        return cell
    }
    
    
    //....///
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("indexPath : \(indexPath)")
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        let headerViewCell = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "HeaderProfileCollectionReusableView", for:indexPath) as! HeaderProfileCollectionReusableView
        
        if let user = self.user {
            headerViewCell.userInCell = user
            
            headerViewCell.degateOfHeaderProfileCollectionReusableView = self
            headerViewCell.thirdDegateOfHeaderProfileCollectionReusableView = self
        }
        
        return headerViewCell
    }
    
    //MARK: - cell size
    
    // delegation
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.size.width / 3  , height: collectionView.frame.size.width / 3  )
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return -2
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}


extension ProfileViewController: HeaderProfileCollectionReusableViewDelegate, UIImagePickerControllerDelegate {
    
    func takeProfileImage() {
        
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        present(imagePicker, animated: true, completion:nil)
        
    }
    
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        guard let currentUser = Api.UserAPI.CURRENT_USER else {
            return
        }
        
        
        let selectedImageUrl = info[.imageURL]
        
        let profileImageRef = storageRef.child("profile_photo").child(currentUser.email!)
        
        profileImageRef.putFile(from: selectedImageUrl as! URL, metadata: nil) { metadata, error in
            if error != nil {
                return
            } else {
                
                //downloading Profile Image Url
                profileImageRef.downloadURL(completion: { (url, error) in
                    if error != nil {
                        return
                    }else {
                        let profilePhotoUrl  = url?.absoluteString
                        
                        self.sendDataToDatabase(profilePhotoUrl: profilePhotoUrl!)
                        
                    }
                })
                
                return
            }
        }
        
        dismiss(animated: true, completion: nil)
        
        self.collectionView.reloadData() //doesn't work for updating profileImage instantly
        
    }
    
    func sendDataToDatabase(profilePhotoUrl: String) {
        
        guard let currentUser = Api.UserAPI.CURRENT_USER else {
            return
        }
        
        let postRef = Api.UserAPI.REF_USERS
        let newPostId = postRef.child(currentUser.uid)
        
        newPostId.updateChildValues(["profileImageUrl":profilePhotoUrl]) { (error, DatabaseReference) in
            if error != nil {
                SVProgressHUD.showError(withStatus: error?.localizedDescription)
                return
            }
            
            SVProgressHUD.showSuccess(withStatus: "Success")
        }
    }
}

extension ProfileViewController: SettingUITableViewControllerDelegate {
    
    func updateUserInfoRealTime() {
        
        self.fetchUser()
        
    }
}


extension ProfileViewController: HeaderProfileCollectionReusableViewThirdDelegate {
    func goToFollowingVC() {
        
        performSegue(withIdentifier: "Profile_Following", sender: user.id)
    }
    
    func goToFollowerVC() {
        performSegue(withIdentifier: "Profile_Follower", sender: user.id)
    }
    
    
    func goToSettingVC() {
        
        performSegue(withIdentifier: "Profile_SettingSegue", sender: nil
            
        )
    }
    
}

extension ProfileViewController: PhotoCollectionViewCellDelegate {
    
    func goToProfileTableVCFromProfileVC(userId: String) {
        performSegue(withIdentifier: "Profile_ProfileTable", sender: user.id)
    }
    
    //MARK: - Prepare for segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "Profile_SettingSegue" {
            
            let settingVC = segue.destination as? SettingUITableViewController
            
            settingVC?.delegateOfSettingUITableViewController = self
            
        }
        
        if segue.identifier == "Profile_ProfileTable" {
            
            let profileTableVC = segue.destination as? ProfileTableViewController
            
            let userId = sender as? String
            
            profileTableVC!.userId = userId!
        }
        
        if segue.identifier == "Profile_Following" {
            
            let followingVC = segue.destination as? FollowingViewController
            
            let userId = sender as? String
            followingVC!.userId = userId!
        }
        
        if segue.identifier == "Profile_Follower" {
            
            let followVC = segue.destination as? FollowerViewController
            
            let userId = sender as? String
            
            followVC!.userId = userId!
        }
    }
}



