import UIKit

class FollowingViewController: UIViewController,UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    var users:[UserModel] = []
    var userId:String?
    var userOfCurrentView:UserModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadUsers()
        
    }
    
    func loadUsers(){
        //works for currentUser
        Api.UserAPI.observeUsersForNonCurrentUsers { (user) in
            
            self.isFollowing(userId: self.userId!, completed: { (boolvalue) in
                user.isFollowed = boolvalue
            }, completed2: { (arrayOfUsers) in
                
                arrayOfUsers.forEach({ (uid) in
                    if uid == user.id {
                        self.users.append(user)
                    }
                    
                    self.tableView.reloadData()
                })
            })
        }
        
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = 100
    }
    
    func isFollowing(userId: String, completed:@escaping(Bool) -> Void,completed2: @escaping(Array<String>)->Void){
        Api.FollowAPI.followingCheckForNonCurrentUser(userId: userId, completed: completed, completed2: completed2)
        
    }
    
    
    //MARK: - TableView Methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "PeopleTableViewCell", for: indexPath) as! PeopleTableViewCellForFollowing
        
        let user = users[indexPath.row]
        
        cell.userInCell = user
        
        cell.delegate = self
        
        return cell
    }
}


extension FollowingViewController : PeopleTableViewCellForFollowingDelegate {
    func goToProfileUserVCfromFollowing(userId: String) {
        performSegue(withIdentifier:"Following_ProfileUser" , sender: userId) 
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "Following_ProfileUser" {
            
            let profileUserVC = segue.destination as! ProfileUserViewController
            
            let userId = sender as! String
            
            profileUserVC.userId = userId
        }
    }
}
