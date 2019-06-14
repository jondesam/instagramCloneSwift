//
//  commentTableViewCell.swift
//  instagramCloneSwift
//
//  Created by MyMac on 2019-05-12.
//  Copyright © 2019 Apex. All rights reserved.
//

import UIKit
import FirebaseDatabase
protocol commentTableViewCellDelegate {
    
      func goToProfileUserVC(userId: String)
}

class commentTableViewCell: UITableViewCell {


    @IBOutlet weak var profileImageView: UIImageView!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var commentLabel: UILabel!
    
    var delegateOfcommentTableViewCell: commentTableViewCellDelegate?
    
    var comment: Comment? {
        didSet {
            updateCommentView()
        }
    }
    
    var userInCell: UserModel? {
        didSet {
            setUpUserInfo()
        }
    }
    
    
    
    func updateCommentView(){
        commentLabel.text = comment!.commentText
    }
    
    func setUpUserInfo(){
        nameLabel.text = userInCell?.username
        if let photoUrlString = userInCell?.profileImageUrl {
            let photoUrl = URL(string: photoUrlString)
         
            profileImageView.sd_setImage(with: photoUrl, placeholderImage:UIImage(named: "placeholderImg"))
        }
    }

    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        //Aloow user to touch imageView as button
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.nameLabel_TouchUpInside))
        
        nameLabel.addGestureRecognizer(tapGesture)
        nameLabel.isUserInteractionEnabled = true
    }
    
    @objc func nameLabel_TouchUpInside() {
        if let id = userInCell!.id {
            print("userId from PeopleTAbleViewCell: \(id)")
            delegateOfcommentTableViewCell?.goToProfileUserVC(userId: id)
        
        }
    }
    
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
