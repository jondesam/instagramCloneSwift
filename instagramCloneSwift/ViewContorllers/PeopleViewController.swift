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

    
    //MARK: - TableView Methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "PeopleTableViewCell", for: indexPath) as! PeopleTableViewCellFromProfile
        
        let user = users[indexPath.row]
        
        cell.userInCell = user
        
        //cell.peopleVC = self //to make "peopleVC variable" to instantiate and perform "ProfileSegue" in PeopleTableViewCell
        
        cell.delegateOfPeopleTableViewFromProfileCell = self
        
        return cell
    }
    

     //to transer sender from "performsegue" method in PeopleTableViewCell
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ProfileUserSegue" {
            
            let profileUserVC = segue.destination as! ProfileUserViewController
            
            let userId = sender as! String
            
            profileUserVC.userId = userId
            
            profileUserVC.secondDelegateOfHeaderProfileCollectionReusableViewInPUVC = self
        }
    }

}

extension PeopleViewController: PeopleTableViewCellFromProfileDelegate {
    func goToProfileUserVC(userId: String) {
        performSegue(withIdentifier:"ProfileUserSegue" , sender: userId)
    }
}

extension PeopleViewController: HeaderProfileCollectionReusableViewSecondDelegate {
    
    func updateFollowButton(forUser userInCell: UserModel) {
        for user in self.users {
            if user.id == userInCell.id {
                user.isFollowed = userInCell.isFollowed
                tableView.reloadData()
            }
        }
    
    }
    

    
    
}
