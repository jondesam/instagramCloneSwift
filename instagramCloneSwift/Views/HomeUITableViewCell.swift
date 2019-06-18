//
//  HomeUITableViewCell.swift
//  instagramCloneSwift
//
//  Created by MyMac on 2019-05-09.
//  Copyright © 2019 Apex. All rights reserved.
//

import UIKit
import SVProgressHUD

protocol HomeUITableViewCellDelegate { //Boss of HomeViewController
    
    func goToCommentVC(postId: String)
    
    func goToProfileUserVC(userId: String)
    
}

class HomeUITableViewCell: UITableViewCell {
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var postImageView: UIImageView!
    @IBOutlet weak var likeImageView: UIImageView!
    @IBOutlet weak var commentImageView: UIImageView!
    @IBOutlet weak var shareImageView: UIImageView!
    @IBOutlet weak var likeCountButton: UIButton!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    var delegateOfHomeUITableViewCell: HomeUITableViewCellDelegate?
    
   // var homeVC: HomeViewController? //delegation pattern is used instead
    
    var post: Post? {
        didSet {
            updateHomeView()
        }
    }
    
    var userInCell: UserModel? {
        didSet {
            setUpUserInfo()
        }
    }
    
    func updateHomeView(){
        descriptionLabel.text = post!.description
        
        if let photoUrlString = post!.photoURL {
            let photoUrl = URL(string: photoUrlString)
            
           postImageView.sd_setImage(with: photoUrl)
            
            
//            sd_setImage(with: photoUrl, placeholderImage:UIImage(named:
//                "placeholderImg.jpeg") )
        }
        
        self.updateLike(post: post!)

/* Comment out to update cell directly without observing cell
        
        //real time likes update while scrolling
//        Api.PostAPI.observePost(withId: post!.id!) { (post) in
//             self.updateLike(post: post)
//        }
        
        
//        Api.PostAPI.REF_POSTS.child(post!.id!).observe(.childChanged) { (snapshot) in
//          //  print(snapshot)
//            if let value = snapshot.value as? Int {
//                self.likeCountButton.setTitle("\(value) likes", for: UIControl.State.normal)
//            }
//        }
        
//            Api.PostAPI.observeLikeCount(withPostId: post!.id!) { (value) in
//             self.likeCountButton.setTitle("\(value) likes", for: UIControl.State.normal)
//        }
  */
    }
    
    
    func updateLike(post: Post){
        
        let imageName = post.likes == nil || !post.isLiked! ? "like":"likeSelected"
        
        likeImageView.image = UIImage(named: imageName)
        
        //if default "likeCount"is none this will be never called
        guard let count = post.likeCount else {
            return
        }
        
//        if let count = post.likeCount {
            if  count != 0 {
                likeCountButton.setTitle("\(count) likes ", for: UIControl.State.normal)
                
            } else  {
                likeCountButton.setTitle("Be the first one ", for: UIControl.State.normal)
                
            }
       // }
        
        // there is no false "like" node just deleted
        //        if post.isLiked == false {
        //            likeImageView.image = UIImage(named: "like")
        //        } else {
        //            likeImageView.image = UIImage(named: "likeSelected" )
        //        }
    }
    
    func setUpUserInfo() {
        self.nameLabel.text = userInCell!.username
        
        if let photoUrlString = userInCell!.profileImageUrl {
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
        let tapGestureOfLikeImageView = UITapGestureRecognizer(target: self, action: #selector(self.likeImageView_TouchUpInside))
        
        likeImageView.addGestureRecognizer(tapGestureOfLikeImageView)
        likeImageView.isUserInteractionEnabled = true
        
      
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.commentImageView_TouchUpInside))
        
        commentImageView.addGestureRecognizer(tapGesture)
        commentImageView.isUserInteractionEnabled = true
   
        
        let tapGestureForNameLabel = UITapGestureRecognizer(target: self, action: #selector(self.nameLabel_TouchUpInside))
        
        nameLabel.addGestureRecognizer(tapGestureForNameLabel)
        nameLabel.isUserInteractionEnabled = true
        
        
    }
    
    @objc func commentImageView_TouchUpInside() {
        if let id = post?.id {
        
            delegateOfHomeUITableViewCell?.goToCommentVC(postId: id)//using protocol and delegation
            
            // performSegue(withIdentifier:sender:) is moved to Intern(HomeViewController) in goToCommentVC(postId:)
//            homeVC?.performSegue(withIdentifier: "commentSegue", sender: id)//need parepare(for segue) method to transfer sender
        
        }
    }
    
    @objc func nameLabel_TouchUpInside() {
        if let id = userInCell!.id {
            
            delegateOfHomeUITableViewCell?.goToProfileUserVC(userId: id)
            
        }
    }
    
    
    
    @objc func likeImageView_TouchUpInside() {
        
      //  postRef = Api.PostAPI.REF_POSTS.child(post!.id!)
        
        Api.PostAPI.incrementLikes( postId: post!.id!, onSuccess: { (post) in
             self.updateLike(post: post)
            
            self.post?.likes = post.likes
            self.post?.isLiked = post.isLiked
            self.post?.likeCount = post.likeCount
            
            
        }) { (errorMessage) in
            SVProgressHUD.showError(withStatus: errorMessage)
        }
     
    }
    


    override func prepareForReuse() {
        super.prepareForReuse()

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
