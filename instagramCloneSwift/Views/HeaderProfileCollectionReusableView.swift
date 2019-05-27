    //
    //  HeaderProfileCollectionReusableView.swift
    //  instagramCloneSwift
    //
    //  Created by MyMac on 2019-05-25.
    //  Copyright © 2019 Apex. All rights reserved.
    //

    import UIKit
    import FirebaseAuth

    class HeaderProfileCollectionReusableView: UICollectionReusableView {
        
        @IBOutlet weak var profileImage: UIImageView!
        @IBOutlet weak var nameLable: UILabel!
        @IBOutlet weak var myPostCountLabel: UILabel!
        @IBOutlet weak var followingCountLabel: UILabel!
        @IBOutlet weak var followersCountLabel: UILabel!
        
        var user: User? {
            didSet {
                updateView()
            }
        }
        
        
        func  updateView() {
     
          //  Api.UserAPI.observeCurrentUse { (user) in
            if let user = user {
                self.nameLable.text = user.username
                
                if let photoUrlString = user.profileImageUrl {
                    let photoUrl = URL(string: photoUrlString)
                    self.profileImage.sd_setImage(with: photoUrl)
                }
            }
            
           
//            }
    }
}
