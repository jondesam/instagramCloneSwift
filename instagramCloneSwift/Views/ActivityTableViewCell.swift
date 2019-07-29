//
//  ActivityTableViewCell.swift
//  instagramCloneSwift
//
//  Created by MyMac on 2019-07-18.
//  Copyright © 2019 Apex. All rights reserved.
//

import UIKit

protocol ActivityTableViewCellDelegate {
    func goToProfileVC(userId: String)
}


class ActivityTableViewCell: UITableViewCell {
    
    @IBOutlet weak var labelToClick: UILabel!
    
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var photoImage: UIImageView!
    
    var delegateOfActivityTableViewCell: ActivityTableViewCellDelegate?
    
    var notification: Notification? {
        didSet {
            updateView()
        }
    }
    
    var userInCell: UserModel? {
        didSet {
            setupUserInfo()
        }
    }
    
    func  updateView(){
        switch notification?.type {
            
        case "feed":
            descriptionLabel.text = "added a new post"
            
            guard let postId = notification!.postId else {
                return
            }
            
            Api.PostAPI.observePost(withPostId: postId) { (post) in
                if let photoUrlString = post.photoUrl {
                    let photoUrl = URL(string: photoUrlString)
                    
                    self.photoImage.sd_setImage(with: photoUrl, placeholderImage:UIImage(named: "placeholderImg"))
                }
            }
            
        default:
            print("")
            
        }
        
        if let timeStamp = notification?.timestamp {
            
            let timestampOfPost = Date(timeIntervalSince1970: Double(timeStamp))
            
            let now = Date()
            
            let components = Set<Calendar.Component>([.second, .minute, .hour, .day, .weekOfMonth])
            dump("componets : \(components)")
            let diff = Calendar.current.dateComponents(components, from: timestampOfPost, to: now)
            print("diff :  \(diff)")
            
            var timeText = ""
            
            if diff.second! <= 0 {
                timeText = "Now"
            }
            if diff.second! > 0 && diff.minute! == 0 {
                timeText =  "\(diff.second!)s"
            }
            if diff.minute! > 0 && diff.hour! == 0 {
                timeText =  "\(diff.minute!)m"
            }
            if diff.hour! > 0 && diff.day! == 0 {
                timeText =  "\(diff.hour!)h"
            }
            if diff.day! > 0 && diff.weekOfMonth! == 0 {
                timeText = "\(diff.day!) d"
            }
            if diff.weekOfMonth! > 0 {
                timeText = "\(diff.weekOfMonth!)w"
            }
            
            print("timeText: \(timeText)")
            
            timeLabel.text = timeText
            
        }
        
   
        
    }
    
    @objc func cell_touchUpInside() {
        print("clicked")
        if let id = notification?.from {
            delegateOfActivityTableViewCell?.goToProfileVC(userId: id)
        }
    }

    
    
    
    func  setupUserInfo(){
        self.nameLabel.text = userInCell?.username
        
        if let photoUrlString = userInCell!.profileImageUrl {
            let photoUrl = URL(string: photoUrlString)
            
            profileImage.sd_setImage(with: photoUrl, placeholderImage:UIImage(named: "placeholderImg"))
        }
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
       
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(cell_touchUpInside))
        
        labelToClick.addGestureRecognizer(tapGesture)
        labelToClick.isUserInteractionEnabled = true
    }
    
    
    
}
