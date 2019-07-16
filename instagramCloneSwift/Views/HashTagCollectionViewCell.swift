//
//  HashTagCollectionViewCell.swift
//  instagramCloneSwift
//
//  Created by MyMac on 2019-07-13.
//  Copyright © 2019 Apex. All rights reserved.
//

import UIKit

protocol HashTagCollectionViewCellDelegate {
      func goToProfileTableVCFromHashTagVC(userId: String)
}

class HashTagCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!

    var delegateOfHashTagCollectionViewCell: HashTagCollectionViewCellDelegate?
    
    var post : Post? {
        didSet {
            updateView()
        }
    }
 
    
    func updateView() {
    
    if let photoUrlString = post!.photoUrl {
    let photoUrl = URL(string: photoUrlString)
  //  print("photoUrl : \(photoUrl)")
    imageView.sd_setImage(with: photoUrl)
    }
    
    
    let tapGestureForPhoto = UITapGestureRecognizer(target: self, action: #selector(self.photo_TouchUpInside))
        
        tapGestureForPhoto.cancelsTouchesInView = false
        
        imageView.addGestureRecognizer(tapGestureForPhoto)
        
        imageView.isUserInteractionEnabled = true
       

    }
    
    
    
    
    @objc func photo_TouchUpInside() {
        
        if let id = post!.uid {
//print("post!.uid: \(post!.uid)")
            delegateOfHashTagCollectionViewCell?.goToProfileTableVCFromHashTagVC(userId: id)
            
        }
    }
    
}
