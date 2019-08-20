import UIKit

class ProfileUserViewController: UIViewController, UINavigationControllerDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var secondDelegateOfHeaderProfileCollectionReusableViewInPUVC: HeaderProfileCollectionReusableViewSecondDelegate?
    
    var delegateofSettingUITableViewControllerInPUVC:SettingUITableViewControllerDelegate?
    
    var indexPath: IndexPath?
    var user: UserModel!
    var posts: [Post] = []  
    var userId = ""
    var usersInCell = [UserModel]()
    let cellId = "usersCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.dataSource = self
        collectionView.delegate = self
        fetchUser()
        fectchMyPosts()
    }
    
    
    //MARK: fetching User info
    func fetchUser() {
        Api.UserAPI.observeUser(withUserId: userId) { (user) in
            self.isFollowing(userId: user.id!, completed: { (boolValue) in
                
                user.isFollowed = boolValue
                
                self.user = user
                self.navigationItem.title = user.username
                self.collectionView.reloadData()
                
            })
        }
    }
    
    func isFollowing(userId: String, completed:@escaping(Bool) -> Void){
        Api.FollowAPI.followedCheck(userId: userId, completed: completed)
    }
    
    
    //MARK: fecthincg Posts
    func fectchMyPosts() {
        Api.MyPostsAPI.REF_MYPOSTS.child(userId).observe(.childAdded) { (snapshot) in
            
            Api.PostAPI.observePost(withPostId: snapshot.key, completion: { (post) in
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
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        let headerViewCell = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "HeaderProfileCollectionReusableView", for:indexPath) as! HeaderProfileCollectionReusableView
        
        headerViewCell.updateView()
        
        if let user = self.user {
            headerViewCell.userInCell = user
            
            headerViewCell.secondDegateOfHeaderProfileCollectionReusableViewInHPCRV = self.secondDelegateOfHeaderProfileCollectionReusableViewInPUVC
            headerViewCell.thirdDegateOfHeaderProfileCollectionReusableView = self
            
        }
        
        return headerViewCell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        return  self.indexPath = indexPath
    }
    
    //MARK: - cell size
    
    //delegation
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

extension ProfileUserViewController: HeaderProfileCollectionReusableViewThirdDelegate {
    func goToFollowingVC() {
        performSegue(withIdentifier: "ProfileUser_Following", sender: user.id)
    }
    
    func goToFollowerVC() {
        performSegue(withIdentifier: "ProfileUser_Follower", sender: user.id)
    }
    
    func goToSettingVC() {
        performSegue(withIdentifier: "ProfileUser_SettingSegue", sender: nil )
    }
}


extension ProfileUserViewController: PhotoCollectionViewCellDelegate {
    
    func goToProfileTableVCFromProfileVC(userId: String) {
        
        performSegue(withIdentifier: "ProfileUser_ProfileTable", sender: userId)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "ProfileUser_SettingSegue" {
        }
        
        if segue.identifier == "ProfileUser_ProfileTable" {
            
            let profileTableVC = segue.destination as? ProfileTableViewController
            
            let userId = sender as? String
            
            profileTableVC!.userId = userId!
        }
        
        if segue.identifier == "ProfileUser_Following" {
            
            let followingVC = segue.destination as? FollowingViewController
            
            let userId = sender as? String
            
            followingVC!.userId = userId!
        }
        
        if segue.identifier == "ProfileUser_Follower" {
            
            let followVC = segue.destination as? FollowerViewController
            
            let userId = sender as? String
            
            followVC!.userId = userId!
        }
        
    }
    
}
