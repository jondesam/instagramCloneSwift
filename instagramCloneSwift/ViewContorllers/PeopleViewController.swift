//
//  PeopleViewController.swift
//  instagramCloneSwift
//
//  Created by MyMac on 2019-06-01.
//  Copyright © 2019 Apex. All rights reserved.
//

import UIKit

class PeopleViewController: UIViewController,UITableViewDataSource {
  
    @IBOutlet weak var tableView: UITableView!
    var users:[UserModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        loadUsers()
        
    }
    
    func loadUsers(){
    
        Api.UserAPI.observeUsers { (user) in
            self.isFollowing(userId: user.id!, completed: { (boolValue) in
                    
                    user.isFollowed = boolValue
                    
                    self.users.append(user)
                    
                    self.tableView.reloadData()
            })
        }
         tableView.estimatedRowHeight = 100
         tableView.rowHeight = 100
       // tableView.rowHeight = UITableView.automaticDimension
    }
    
    func isFollowing(userId: String, completed:@escaping(Bool) -> Void){
        Api.FollowAPI.isFollowing(userId: userId, completed: completed)
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "PeopleTableViewCell", for: indexPath) as! PeopleTableViewCell
        
        let user = users[indexPath.row]
        
        cell.userInCell = user
    
      //  cell.peopleVC = self
        
    
        return cell
    }
    

}
