//
//  HomeUITableViewCell.swift
//  instagramCloneSwift
//
//  Created by MyMac on 2019-05-09.
//  Copyright © 2019 Apex. All rights reserved.
//

import UIKit
import SVProgressHUD
import  AVFoundation
import KILabel

protocol HomeUITableViewCellDelegate { //Boss of HomeViewController
    
    func goToCommentVC(postId: String)
    
    func goToProfileUserVC(userId: String)
    
    func goToHashTag(tag: String)
    
}

class HomeUITableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var postImageView: UIImageView!
    @IBOutlet weak var likeImageView: UIImageView!
    @IBOutlet weak var commentImageView: UIImageView!
    @IBOutlet weak var shareImageView: UIImageView!
    @IBOutlet weak var likeCountButton: UIButton!
    @IBOutlet weak var descriptionLabel: KILabel!
    
    @IBOutlet weak var volumeView: UIView!
    @IBOutlet weak var volumeButton: UIButton!
    
    var isMuted = true
    
    @IBAction func wholePostButton(_ sender: Any) {
        if isMuted {
            isMuted = !isMuted
            player?.isMuted = isMuted
            volumeButton.setImage(UIImage(named: "Icon_Volume"), for: UIControl.State.normal)
        } else {
            isMuted = !isMuted
            player?.isMuted = isMuted
            volumeButton.setImage(UIImage(named: "Icon_Mute"), for: UIControl.State.normal)
        }
    }
    
    
    var delegateOfHomeUITableViewCell: HomeUITableViewCellDelegate?
    var player: AVPlayer?
    var playerLayer: AVPlayerLayer?
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
        
        descriptionLabel.hashtagLinkTapHandler = { label, string, Range in
           // print(string)
            let tag = string.dropFirst()

            self.delegateOfHomeUITableViewCell?.goToHashTag(tag: String(tag))
        }
        
        descriptionLabel.userHandleLinkTapHandler = { label, string, Range in
            // print(string)
            let mention = string.dropFirst()
            print(mention)
            Api.UserAPI.observeUserByUsername(username: String(mention.lowercased()), completion: { (user) in
                self.delegateOfHomeUITableViewCell?.goToProfileUserVC(userId: user.id!)
            })

        }
        
        
        layoutIfNeeded() //layout video
        if let photoUrlString = post!.photoUrl {
            let photoUrl = URL(string: photoUrlString)
            
           postImageView.sd_setImage(with: photoUrl)
            
            
            if let videoUrlString = post?.videoUrl,  let videoUrl = URL(string: videoUrlString) {
                print("videoUrl: \(videoUrlString)")
                volumeView.isHidden = false
                
                
                player = AVPlayer(url: videoUrl)
                playerLayer = AVPlayerLayer(player: player)
                playerLayer?.frame = postImageView.frame
                playerLayer?.frame.size.width = UIScreen.main.bounds.width
                self.contentView.layer.addSublayer(playerLayer!)
                volumeView.layer.zPosition = 1
                player?.play()
                player?.isMuted = isMuted
                
            }
            
//            sd_setImage(with: photoUrl, placeholderImage:UIImage(named:
//                "placeholderImg.jpeg") )
        }
        
        self.updateLike(post: post!)


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
        volumeView.isHidden = true
        isHidden = false
        isSelected = false
        isHighlighted = false
        profileImageView.image = UIImage(named: "placeholderImg")
      
      
        playerLayer?.removeFromSuperlayer() //preventing from showing on another post
        player?.pause() // pause the video when it is out of screen 
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
