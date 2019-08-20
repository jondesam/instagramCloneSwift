
import UIKit

class FollowerViewController: UIViewController,UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    var users:[UserModel] = []
    
    var userId:String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadUsers()
        
    }
    
    func loadUsers(){
        
        Api.UserAPI.observeUsersForNonCurrentUsers { (user) in
            
            self.isFollowing(userId: user.id!, completed: { (boolValue) in
                user.isFollowed = boolValue
                
                Api.FollowAPI.removeUnfollowingUsers(userId: self.userId!, completion: { (arrayOfUsers) in
            
                    arrayOfUsers.forEach({ (uid) in
                        
                        if uid == user.id {
                            self.users.append(user)
                        }
                        
                        self.tableView.reloadData()
                        
                    })
                })
            })
        }
        
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = 100
    }
    
    
    func isFollowing(userId: String, completed:@escaping(Bool) -> Void){
        Api.FollowAPI.followedCheck(userId: userId, completed: completed)
    }
    
    
    //MARK: - TableView Methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "PeopleTableViewCell", for: indexPath) as! PeopleTableViewCellForFollower
        
        let user = users[indexPath.row]
        
        cell.userInCell = user
        cell.delegate = self
        
        return cell
    }
}


extension FollowerViewController: PeopleTableViewCellForFollowerDelegate{
    func goToProfileUserVCfromFollower(userId: String) {
        
        performSegue(withIdentifier:"Follower_ProfileUser" , sender: userId)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "Follower_ProfileUser" {
            
            let profileUserVC = segue.destination as! ProfileUserViewController
            
            let userId = sender as! String
            
            profileUserVC.userId = userId
            
        }
    }
}








