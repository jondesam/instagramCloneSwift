//
//  HomeViewController.swift
//  instagramCloneSwift
//
//  Created by MyMac on 2019-04-29.
//  Copyright © 2019 Apex. All rights reserved.
//

import UIKit
import FirebaseAuth
import SVProgressHUD

class HomeViewController: UIViewController {
   
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        //SVProgressHUD.dismiss()
        print(Auth.auth().currentUser?.email as Any)
        
    }
    
   
    


}
