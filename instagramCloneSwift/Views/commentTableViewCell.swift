//
//  commentTableViewCell.swift
//  instagramCloneSwift
//
//  Created by MyMac on 2019-05-12.
//  Copyright © 2019 Apex. All rights reserved.
//

import UIKit
import FirebaseDatabase

class commentTableViewCell: UITableViewCell {

  //  let postId = "Lebw2XyQmNdGAbsOn44"
    @IBOutlet weak var profileImageView: UIImageView!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var commentLabel: UILabel!
    
    var comment: Comment? {
        didSet {
            updateCommentView()
        }
    }
    
    var user: User? {
        didSet {
            setUpUserInfo()
        }
    }
    
    
    
    func updateCommentView(){
        commentLabel.text = comment!.commentText
        
//        if let photoUrlString = post!.photoURL {
//            let photoUrl = URL(string: photoUrlString)
//
//            profileImageView.sd_setImage(with: photoUrl)
//        }
     //   setUpUserInfo()
        
    }
    
    func setUpUserInfo(){
        nameLabel.text = user?.username
        if let photoUrlString = user?.profileImageUrl {
            let photoUrl = URL(string: photoUrlString)
         
            
            profileImageView.sd_setImage(with: photoUrl, placeholderImage:UIImage(named: "placeholderImg"))
        }
    }


//        if let uid = comment?.uid {
//            Database.database().reference().child("comments").child(postId).observeSingleEvent(of: DataEventType.value) { (snapshot:DataSnapshot) in
//                if  let dict = snapshot.value as? [String:Any]{
//
//                    let user = User.transformUser(dict: dict)
//                    self.nameLabel.text = user.username
//
//                    if let photoUrlString = user.profileImageUrl {
//                        let photoUrl = URL(string: photoUrlString)
//                        self.profileImageView.sd_setImage(with: photoUrl, placeholderImage:UIImage(named: "placeholderImg"))
//                    }
//                }
//            }
//        }
//    }
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
