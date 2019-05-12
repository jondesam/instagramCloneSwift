//
//  commentTableViewCell.swift
//  instagramCloneSwift
//
//  Created by MyMac on 2019-05-12.
//  Copyright © 2019 Apex. All rights reserved.
//

import UIKit

class commentTableViewCell: UITableViewCell {

    @IBOutlet weak var profileImageView: UIImageView!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var commentLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
