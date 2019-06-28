//
//  PhotoCollectionViewCell.swift
//  instagramCloneSwift
//
//  Created by MyMac on 2019-05-27.
//  Copyright © 2019 Apex. All rights reserved.
//

import UIKit

protocol PhotoCollectionViewCellDelegate {
    
    func goToDetailVC(postId: String)

}

class PhotoCollectionViewCell: UICollectionViewCell {
    
    var delegateOfPhotoCollectionViewCell: PhotoCollectionViewCellDelegate?
    
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

        let tapGestureForPhoto = UITapGestureRecognizer(target: self, action: #selector(self.photo_TouchUpInside))
        
        photo.addGestureRecognizer(tapGestureForPhoto)
        photo.isUserInteractionEnabled = true
        
    }
    
    
    @objc func photo_TouchUpInside() {
        
        if let id = post!.id {
            delegateOfPhotoCollectionViewCell?.goToDetailVC(postId: id)
            
        }
    }
    
    
}
