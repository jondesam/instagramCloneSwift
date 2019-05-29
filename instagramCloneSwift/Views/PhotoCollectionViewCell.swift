//
//  PhotoCollectionViewCell.swift
//  instagramCloneSwift
//
//  Created by MyMac on 2019-05-27.
//  Copyright © 2019 Apex. All rights reserved.
//

import UIKit

class PhotoCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var photo: UIImageView!
    var post : Post? {
        didSet{
            updateView()
        }
    }
    
    
    func updateView() {
        
        
        if let photoUrlString = post!.photoURL {
            let photoUrl = URL(string: photoUrlString)
            
            photo.sd_setImage(with: photoUrl)
        }

        
    }
}
