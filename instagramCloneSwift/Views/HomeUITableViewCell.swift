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
    
    var post: Post? {
        didSet {
            updateHomeView()
        }
    }
    
    
    func updateHomeView(){
        descriptionLabel.text = post!.description
        
        if let photoUrlString = post!.photoURL {
            let photoUrl = URL(string: photoUrlString)
            
            postImageView.sd_setImage(with: photoUrl)
        }
        setUpUserInfo()
        
    }
    
    func setUpUserInfo() {
        if let uid = post?.uid {
            Database.database().reference().child("users").child(uid).observeSingleEvent(of: DataEventType.value) { (snapshot:DataSnapshot) in
                if  let dict = snapshot.value as? [String:Any]{
                   
                    let user = User.transformUser(dict: dict)
                    self.nameLabel.text = user.username
                    
                    if let photoUrlString = user.profileImageUrl {
                        let photoUrl = URL(string: photoUrlString)
                        self.profileImageView.sd_setImage(with: photoUrl, placeholderImage:UIImage(named: "placeholderImg"))
                    }
                }
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
