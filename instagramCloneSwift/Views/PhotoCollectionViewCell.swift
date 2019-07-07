//
//  PhotoCollectionViewCell.swift
//  instagramCloneSwift
//
//  Created by MyMac on 2019-05-27.
//  Copyright © 2019 Apex. All rights reserved.
//

import UIKit

protocol PhotoCollectionViewCellDelegate {
    
    func goToProfileTableVC(userId: String)

}


class PhotoCollectionViewCell: UICollectionViewCell,UICollectionViewDelegate {
    
    var delegateOfPhotoCollectionViewCell: PhotoCollectionViewCellDelegate?
    
    @IBOutlet weak var photo: UIImageView!
    
    var post : Post? {
        didSet{
            updateView()
        }
    }
    

    override func awakeFromNib() {
        super.awakeFromNib()
        
        
    }
    
    
    func updateView() {
        
        if let photoUrlString = post!.photoUrl {
            let photoUrl = URL(string: photoUrlString)
            
            photo.sd_setImage(with: photoUrl)
        }

        let tapGestureForPhoto = UITapGestureRecognizer(target: self, action: #selector(self.photo_TouchUpInside))
        
        photo.addGestureRecognizer(tapGestureForPhoto)
        photo.isUserInteractionEnabled = true

        
        
//        let tap = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
//
//
//        tap.cancelsTouchesInView = false
//
//        self.addGestureRecognizer(tap)
        
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
          print("indexPath")
    }
    
  
    
    
    
    @objc func photo_TouchUpInside() {
        
        if let id = post!.uid {
            print("post!.uid: \(post!.uid)")
            delegateOfPhotoCollectionViewCell?.goToProfileTableVC(userId: id)
            
        }
    }
    
    
}

extension UICollectionView {
//
//    func indexPathForView(view: AnyObject) -> NSIndexPath? {
//        let originInCollectioView = self.convert(CGPointZero, from: (view as! UIView))
//        return self.indexPathForItemAtPoint(originInCollectioView) as NSIndexPath?
//    }
}
