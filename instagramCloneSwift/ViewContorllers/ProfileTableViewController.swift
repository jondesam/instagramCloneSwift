import UIKit

class ProfileTableViewController: UITableViewController {
    
    var postz = [Post]()
    var userz = [UserModel]()
    let cellId = "PostCell"
    var userId: String?
    var indexPath: IndexPath?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
     
        tableView.rowHeight = 440
        tableView.estimatedRowHeight = 600
        loadPosts()
    }

    
    func passIndexPath(indexPath: IndexPath) {
        self.indexPath = indexPath
    }
    
    func loadPosts() {
        
        Api.MyPostsAPI.fetchMyPosts(currentUser: userId!) { (key) in
            Api.PostAPI.observePost(withPostId: key, completion: { (post) in
              
                self.fetchUser(uid: self.userId!, completed: {
                    self.postz.append(post)
                    self.tableView.reloadData()
                    
                })
            })
        }
    }
    
    func fetchUser(uid: String, completed: @escaping () -> Void ){
        
        Api.UserAPI.observeUser(withUserId: uid) { (user) in
            
            self.userz.append(user)
            completed()
        }
    }
    
    
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return postz.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! HomeUITableViewCell
        
        let post = postz.reversed()[indexPath.row]
        let user = userz.reversed()[indexPath.row]
        
        cell.post = post
        
        cell.userInCell = user
        
        cell.delegateOfHomeUITableViewCell = self
        
        return cell
        
    }
    
 
}

extension ProfileTableViewController: HomeUITableViewCellDelegate //Intern of GoToCommentVcProtocol
{
    func goToHashTag(tag: String) {
         performSegue(withIdentifier: "ProfileTable_HashTagSegue", sender: tag )
    }
    
    func goToCommentVC(postId: String) {
        performSegue(withIdentifier: "ProfileTable_comment" , sender: postId)
    }
    func goToProfileUserVC(userId: String) {
        performSegue(withIdentifier: "ProfileTable_profileUser", sender: userId)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "ProfileTable_comment" {
            let commentVC = segue.destination as! commentViewController
            let postId = sender as! String
            commentVC.postId = postId
        }
        
        if segue.identifier == "ProfileTable_profileUser" {
            let profileUserVC = segue.destination as! ProfileUserViewController
            let userId = sender as! String
            profileUserVC.userId = userId
        }
        
        if segue.identifier == "ProfileTable_HashTagSegue" {
            let hashTagVC = segue.destination as! HashTagViewController
            let tag = sender as! String
            hashTagVC.tag = tag
        }
    }
}
