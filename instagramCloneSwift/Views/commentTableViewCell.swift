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


    @IBOutlet weak var profileImageView: UIImageView!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var commentLabel: UILabel!
    
    var comment: Comment? {
        didSet {
            updateCommentView()
        }
    }
    
    var user: UserModel? {
        didSet {
            setUpUserInfo()
        }
    }
    
    
    
    func updateCommentView(){
        commentLabel.text = comment!.commentText
        

        
    }
    
    func setUpUserInfo(){
        nameLabel.text = user?.username
        if let photoUrlString = user?.profileImageUrl {
            let photoUrl = URL(string: photoUrlString)
         
            profileImageView.sd_setImage(with: photoUrl, placeholderImage:UIImage(named: "placeholderImg"))
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
