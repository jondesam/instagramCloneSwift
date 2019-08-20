import UIKit

class ActivityViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var notifications = [Notification]()
    var users = [UserModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        loadingNotification()
    }
    
    
    func loadingNotification() {
        
        guard let currentUser = Api.UserAPI.CURRENT_USER else {
            return
        }
        
        Api.Norification.observeNotification(with: currentUser.uid) { (notification) in
            
            guard let uid = notification.from else {
                return
            }
            
            self.fetchUser(uid: uid, completed: {
                self.notifications.insert(notification, at: 0)
                self.tableView.reloadData()
            })
        }
    }
    
    func fetchUser(uid: String, completed: @escaping () -> Void ){
        
        Api.UserAPI.observeUser(withUserId: uid) { (user) in
            self.users.insert(user, at: 0)
            completed()
        }
    }
}

extension ActivityViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notifications.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ActivityTableViewCell", for: indexPath) as! ActivityTableViewCell
        
        let notification = notifications[indexPath.row]
        let user = users[indexPath.row]
        cell.notification = notification
        cell.userInCell = user
        cell.delegateOfActivityTableViewCell = self
        
        return cell
    }
    
    
}

extension ActivityViewController : ActivityTableViewCellDelegate {
    
    func goToProfileVC(userId: String) {
        performSegue(withIdentifier: "Activity_ProfileUserSegue", sender: userId)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Activity_ProfileUserSegue" {
            let profileVC = segue.destination as? ProfileUserViewController
            let userId = sender as! String
            profileVC?.userId = userId
        }
    }

}
