//
//  ProfileViewController.swift
//  instagramCloneSwift
//
//  Created by MyMac on 2019-04-29.
//  Copyright © 2019 Apex. All rights reserved.
//

import UIKit
import FirebaseStorage
import FirebaseAuth
import FirebaseDatabase
import SVProgressHUD

class ProfileViewController: UIViewController,UIImagePickerControllerDelegate, UINavigationControllerDelegate, UICollectionViewDataSource  {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var user: User!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.dataSource = self
        fetchUser()
        
        
    }
    
    func fetchUser() {
        Api.UserAPI.observeCurrentUse { (user) in
            
            self.user = user
            self.collectionView.reloadData()
            
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCell" , for: indexPath)
        
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let headerViewCell = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "HeaderProfileCollectionReusableView", for:indexPath) as! HeaderProfileCollectionReusableView
      
        headerViewCell.updateView()
        
        if let user = self.user {
              headerViewCell.user = user
        }
      
        return headerViewCell
    }
    

    @IBAction func buttonLogOut(_ sender: Any) {
        
        do {
            try  Auth.auth().signOut()
        } catch let logOutError {
            print(logOutError)
        }
        //print(Auth.auth().currentUser?.email)
        
        let storyboard =  UIStoryboard(name: "Main", bundle: nil)
        
        let logInVC = storyboard.instantiateViewController(withIdentifier: "LogInViewController")
        
        present(logInVC, animated: true, completion: nil)
        
    }
}










