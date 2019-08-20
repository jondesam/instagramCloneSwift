import UIKit

class DetailViewController: UIViewController {
    
    var postId:String = ""
    var post =  Post()
    var user = UserModel()
    var cellId = "PostCell"
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadPost()
        tableView.estimatedRowHeight = 600
    }
    
    func loadPost(){
        Api.PostAPI.observePost(withPostId: postId) { (post) in
            
            guard let postUid = post.uid  else {
                return
            }
            
            self.fetchUser(uid: postUid, completed: {
                
                self.post = post
                
                self.tableView.reloadData()
            })
        }
    }
    
    func fetchUser(uid:String, completed: @escaping () -> Void) {
        
        Api.UserAPI.observeUser(withUserId: uid) { (userModel) in
            
            self.user = userModel
            
            completed()
        }
    }
}

extension DetailViewController : UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId , for: indexPath) as! HomeUITableViewCell
        
        cell.post = post
        cell.userInCell = user
        cell.delegateOfHomeUITableViewCell = self
        
        return cell
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "Detail_commentVC" {
            let commentVC = segue.destination as! commentViewController
            let postId = sender as! String
            commentVC.postId = postId
        }
        
        if segue.identifier == "Detail_profileUserVC" {
            let profileUserVC = segue.destination as! ProfileUserViewController
            let userId = sender as! String
            profileUserVC.userId = userId
        }
    }
}

extension DetailViewController: HomeUITableViewCellDelegate //Intern of GoToCommentVcProtocol
{
    func goToHashTag(tag: String) {
        
    }
    
    func goToCommentVC(postId: String) {
        performSegue(withIdentifier: "Detail_commentVC" , sender: postId)
    }
    func goToProfileUserVC(userId: String) {
        performSegue(withIdentifier: "Detail_profileUserVC", sender: userId)
    }
    
}
