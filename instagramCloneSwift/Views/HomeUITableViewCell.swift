//
//  HomeUITableViewCell.swift
//  instagramCloneSwift
//
//  Created by MyMac on 2019-05-09.
//  Copyright © 2019 Apex. All rights reserved.
//

import UIKit
import FirebaseDatabase

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
        
    }
    
    
    @objc func commentImageView_TouchUpInside() {
      print("commentImageView_TouchUpInside()")
        
        if let id = post?.id {
               homeVC?.performSegue(withIdentifier: "commentSegue", sender: id)
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
