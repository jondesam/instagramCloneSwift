//
//  HomeUITableViewCell.swift
//  instagramCloneSwift
//
//  Created by MyMac on 2019-05-09.
//  Copyright © 2019 Apex. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth

class HomeUITableViewCell: UITableViewCell {
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var postImageView: UIImageView!
    @IBOutlet weak var likeImageView: UIImageView!
    @IBOutlet weak var commentImageView: UIImageView!
    @IBOutlet weak var shareImageView: UIImageView!
    @IBOutlet weak var likeCountButton: UIButton!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    var homeVC: HomeViewController?
    var postRef: DatabaseReference!
    
    var post: Post? {
        didSet {
            updateHomeView()
        }
    }
    
    var user: User? {
        didSet {
            setUpUserInfo()
        }
    }
    
    func updateHomeView(){
        descriptionLabel.text = post!.description
        
        if let photoUrlString = post!.photoURL {
            let photoUrl = URL(string: photoUrlString)
            
            postImageView.sd_setImage(with: photoUrl)
        }
        
        //real time likes update while scrolling
        Api.PostAPI.REF_POSTS.child(post!.id!).observeSingleEvent(of: .value) { (snapshot) in
            if let dict = snapshot.value as? [String:Any] {
                let post = Post.transFromPostPhoto(dict: dict, key: snapshot.key)
                self.updateLike(post: post)
            }
        }
        
        
        
        //   updateLike(post: post!)
        
        Api.PostAPI.REF_POSTS.child(post!.id!).observe(DataEventType.childChanged) { (snapshot) in
            print(snapshot)
            if let value = snapshot.value as? Int {
                self.likeCountButton.setTitle("\(value) likes", for: UIControl.State.normal)
            }
        }
        
    }
    
    
    func updateLike(post: Post){
        // print("This is post.isLiked")
        // print(post.isLiked)
        
        let imageName = post.likes == nil || !post.isLiked! ? "like":"likeSelected"
        
        likeImageView.image = UIImage(named: imageName)
        
        if let count = post.likeCount {
            if  count != 0 {
                likeCountButton.setTitle("\(count) likes ", for: UIControl.State.normal)
                
            } else  {
                likeCountButton.setTitle("Be the first one ", for: UIControl.State.normal)
                
            }
        }
        
        // there is no false "like" node just deleted
        //        if post.isLiked == false {
        //            likeImageView.image = UIImage(named: "like")
        //        } else {
        //            likeImageView.image = UIImage(named: "likeSelected" )
        //        }
    }
    
    func setUpUserInfo() {
        self.nameLabel.text = user!.username
        
        if let photoUrlString = user!.profileImageUrl {
            let photoUrl = URL(string: photoUrlString)
            
            profileImageView.sd_setImage(with: photoUrl, placeholderImage:UIImage(named: "placeholderImg"))
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        profileImageView.layer.cornerRadius = 18
        profileImageView.clipsToBounds = true
        
        nameLabel.text = ""
        descriptionLabel.text = ""
        
        //Aloow user to touch imageView as button
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.commentImageView_TouchUpInside))
        
        commentImageView.addGestureRecognizer(tapGesture)
        commentImageView.isUserInteractionEnabled = true
        
        
        let tapGestureOfLikeImageView = UITapGestureRecognizer(target: self, action: #selector(self.likeImageView_TouchUpInside))
        
        likeImageView.addGestureRecognizer(tapGestureOfLikeImageView)
        likeImageView.isUserInteractionEnabled = true
        
    }
    
    @objc func commentImageView_TouchUpInside() {
        if let id = post?.id {
            homeVC?.performSegue(withIdentifier: "commentSegue", sender: id)
        }
    }
    
    @objc func likeImageView_TouchUpInside() {
        
        postRef = Api.PostAPI.REF_POSTS.child(post!.id!)
        
        incrementLikes(forRef: postRef)
    }
    
    func incrementLikes(forRef ref: DatabaseReference){
        ref.runTransactionBlock({ (currentData: MutableData) -> TransactionResult in
            
            if var post = currentData.value as? [String : AnyObject],
                
                let uid = Auth.auth().currentUser?.uid {
                
                print("post value 1: \(currentData.value)")
                
                var likes: Dictionary<String, Bool>
                
                likes = post["likes"] as? [String : Bool] ?? [:]
                
                print("This is likes from snippet")
                print(likes)
                
                var likeCount = post["likeCount"] as? Int ?? 0
                
                if let _ = likes[uid] {
                    // Unstar the post and remove self from stars
                    likeCount -= 1
                    
                    likes.removeValue(forKey: uid)
                   
                } else {
                    // Star the post and add self to stars
                    likeCount += 1
                    
                    likes[uid] = true
                   
                }
                
                post["likeCount"] = likeCount as AnyObject?
                post["likes"] = likes as AnyObject?
                
                // Set value and report transaction success
                currentData.value = post
                
                return TransactionResult.success(withValue: currentData)
            }
            
            return TransactionResult.success(withValue: currentData)
        }) { (error, committed, snapshot) in
            if let error = error {
                print(error.localizedDescription)
            }
            if let dict = snapshot?.value as? [String:Any] {
                let post = Post.transFromPostPhoto(dict: dict, key: snapshot!.key)
                self.updateLike(post: post)
            }
            
            print("post value 2: \(snapshot?.value)")
        }
    }
    
    
    /// ?? ///
    override func prepareForReuse() {
        super.prepareForReuse()
        print("TTTTTTT")
        
        isHidden = false
        isSelected = false
        isHighlighted = false
        profileImageView.image = UIImage(named: "placeholderImg")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
