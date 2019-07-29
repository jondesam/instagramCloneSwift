
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
            print("user from Following \(user)")
            print("userId from Following \(self.userId)")
            
            self.isFollowing(userId: self.userId!, completed: { (boolvalue) in
                user.isFollowed = boolvalue
            }, completed2: { (arrayOfUsers) in
                
                
                arrayOfUsers.forEach({ (uid) in
                    if uid == user.id {
                        self.users.append(user)
                    }
                    
                    self.tableView.reloadData()
                })
                
                
//                if user.isFollowed == true {
//                    self.users.append(user)
//                    print("users.count : \(self.users.count)")
//                }
//
//                self.tableView.reloadData()
            })
            
//            self.isFollowing(userId: self.userId!, completed: { (boolValue) in
//
//                print("user.username in following\(user.username)")
//
//
//                user.isFollowed = boolValue
//
//                if user.isFollowed == true {
//                   self.users.append(user)
//                    print("users.count : \(self.users.count)")
//                }
//
//                self.tableView.reloadData()
//            })
        }
        
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = 100
        
        // tableView.rowHeight = UITableView.automaticDimension
    }
    
    func isFollowing(userId: String, completed:@escaping(Bool) -> Void,completed2: @escaping(Array<String>)->Void){
        Api.FollowAPI.followingCheckForNonCurrentUser(userId: userId, completed: completed, completed2: completed2)
        
//        followingCheckForNonCurrentUser(userId: userId, completed: completed)
    }
    
    
    //MARK: - TableView Methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "PeopleTableViewCell", for: indexPath) as! PeopleTableViewCellForFollowing
        
        let user = users[indexPath.row]
        
        
        cell.userInCell = user
    //    userOfCurrentView = cell.userInCell
    
     
        cell.delegate = self
        
        
        return cell
    }
    
    
    //to transer sender from "performsegue" method in PeopleTableViewCell
    //    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    //
    //        if segue.identifier == "FollowFollow" {
    //
    //            let followVC = segue.destination as? FollowViewController
    //
    //
    //        }
    
    
    
    //  }
    
    
    
    
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
