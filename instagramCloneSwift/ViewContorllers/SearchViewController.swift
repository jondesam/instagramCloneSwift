//
//  SearchViewController.swift
//  instagramCloneSwift
//
//  Created by MyMac on 2019-06-07.
//  Copyright © 2019 Apex. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController,UISearchBarDelegate {

    var searchBar = UISearchBar()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBar.delegate = self

        searchBar.searchBarStyle = .minimal
        searchBar.placeholder = "Search"
        searchBar.frame.size.width = view.frame.size.width - 60
        
        let searchItem = UIBarButtonItem(customView: searchBar)
        self.navigationItem.rightBarButtonItem = searchItem
    }
    
    
     //MARK: - SearchBar funtions
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        print(searchBar.text)
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print(searchBar.text)
    }
}
