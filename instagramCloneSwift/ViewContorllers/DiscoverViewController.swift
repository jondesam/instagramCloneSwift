//
//  DiscoverViewController.swift
//  instagramCloneSwift
//
//  Created by MyMac on 2019-04-29.
//  Copyright © 2019 Apex. All rights reserved.
//

import UIKit

class DiscoverViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate,UICollectionViewDelegateFlowLayout{
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var posts: [Post] = []
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView.dataSource = self
        collectionView.delegate = self
        
        //loadTopPosts() -moved to viewWillAppear to renew DiscoverView in realtime
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
         loadTopPosts()
        
    }
    
    
    func loadTopPosts() {
        posts.removeAll() //otherwise posts array will be added up continually
        Api.PostAPI.obseveTopPosts { (post) in
            self.posts.append(post)
            self.collectionView.reloadData()
        }
        
    }

    
    //MARK: - CollectionView Methods
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return posts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DiscoveryCollectionViewCell" , for: indexPath) as! PhotoCollectionViewCell
        
        let post = posts[indexPath.row]
        
        cell.post = post
        cell.delegateOfPhotoCollectionViewCell = self
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.size.width / 3  , height: collectionView.frame.size.width / 3  )
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return -5
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
 
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "Discover_DetailSegue" {
            
            let detailVC = segue.destination as? DetailViewController
            
            let postId = sender as? String
          
            detailVC!.postId = postId!
        }
    }

}

extension DiscoverViewController: PhotoCollectionViewCellDelegate {
    
    func goToDetailVC(postId: String) {
        
        performSegue(withIdentifier: "Discover_DetailSegue", sender: postId)
    }
  
    
    
}
