
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
        //wokrs for currentUser
//        guard let currentUser = Api.UserAPI.CURRENT_USER else {
//            return
//        }
        
        Api.UserAPI.observeUsersForNonCurrentUsers { (user) in
            
                self.isFollowing(userId: user.id!, completed: { (boolValue) in
                user.isFollowed = boolValue
                
                    Api.FollowAPI.removeUnfollowingUsers(userId: self.userId!, completion: { (arrayOfUsers) in
                    print("arrayOfUsers in followers : \(arrayOfUsers)")
                    
                    /////using for in
                    //                    for uid in arrayOfUsers {
                    //
                    //                        if uid == user.id {
                    //                            self.users.append(user)
                    //
                    //                        }
                    //
                    //                        print("uid follower :\(uid)")
                    //
                    //                        print("user.id in followers :  \(user.id)")
                    //
                    //                    }
                    //                     self.tableView.reloadData()
                    
                    
                    /////// using forEach
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
        
        // tableView.rowHeight = UITableView.automaticDimension
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
        
        //cell.peopleVC = self //to make "peopleVC variable" to instantiate and perform "ProfileSegue" in PeopleTableViewCell
        
        //  cell.delegateOfPeopleTableViewFromProfileCell = self
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


//extension PeopleViewController: HeaderProfileCollectionReusableViewSecondDelegate {
//
//    func updateFollowButton(forUser userInCell: UserModel) {
//        for user in self.users {
//            if user.id == userInCell.id {
//                user.isFollowed = userInCell.isFollowed
//                tableView.reloadData()
//            }
//        }
//
//    }
//
//
//
//
//}

extension FollowerViewController: PeopleTableViewCellForFollowerDelegate{
    func goToProfileUserVCfromFollower(userId: String) {
        print("Follower_ProfileUser")
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








