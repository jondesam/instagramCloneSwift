//
//  TestCollectionViewCell.swift
//  instagramCloneSwift
//
//  Created by MyMac on 2019-07-10.
//  Copyright © 2019 Apex. All rights reserved.
//

import UIKit

class TestCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var testImage: UIImageView!


    override func awakeFromNib() {
        super.awakeFromNib()
        testImage.image = UIImage(named: "discover")
        
    }
}
