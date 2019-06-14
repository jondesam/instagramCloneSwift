//
//  SearchViewController.swift
//  instagramCloneSwift
//
//  Created by MyMac on 2019-06-07.
//  Copyright © 2019 Apex. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController,UISearchBarDelegate,UITableViewDataSource {

    var searchBar = UISearchBar()
    var users:[UserModel] = []
    
    @IBOutlet weak var tableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBar.delegate = self

        searchBar.searchBarStyle = .minimal
        searchBar.placeholder = "Search"
        searchBar.frame.size.width = view.frame.size.width - 60
        
        let searchItem = UIBarButtonItem(customView: searchBar)
        self.navigationItem.rightBarButtonItem = searchItem
        
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = 100
        doSearch()
    }
    
    func doSearch() {
        if let searchText = searchBar.text?.lowercased(){
            
            users.removeAll()
            tableView.reloadData()
            
            Api.UserAPI.querryUsers(withText: searchText, completion: { (user) in
                
                self.isFollowing(userId: user.id!, completed: { (boolValue) in
                    
                    user.isFollowed = boolValue
                    
                    self.users.append(user)
                    
                    self.tableView.reloadData()
                })
                
            })
        }
    }
    
    func isFollowing(userId: String, completed:@escaping(Bool) -> Void){
        Api.FollowAPI.isFollowing(userId: userId, completed: completed)
    }

    
     //MARK: - SearchBar funtions
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
       doSearch()
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        doSearch()
    }
    
     //MARK: - TableView Methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "PeopleTableViewCell", for: indexPath) as! PeopleTableViewCell
        
        let user = users[indexPath.row]
        
        cell.userInCell = user
        
        cell.delegateOfPeopleTableViewCell = self
        //  cell.peopleVC = self
        
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "Search_ProfileSegue" {
            
            let profileUserVC = segue.destination as! ProfileUserViewController
            
            let userId = sender as! String
            
            profileUserVC.userId = userId
        }
    }
    
}

extension SearchViewController: PeopleTableViewCellDelegate {
    func goToProfileUserVC(userId: String) {
         performSegue(withIdentifier: "Search_ProfileSegue" , sender: userId)
    }
    
}
