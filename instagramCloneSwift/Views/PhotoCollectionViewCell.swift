//
//  PhotoCollectionViewCell.swift
//  instagramCloneSwift
//
//  Created by MyMac on 2019-05-27.
//  Copyright © 2019 Apex. All rights reserved.
//

import UIKit

protocol PhotoCollectionViewCellDelegate {
    
    func goToProfileTableVCFromProfileVC(userId: String)

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
           // print("photoUrl : \(photoUrl)")
            photo!.sd_setImage(with: photoUrl)
        }

        let tapGestureForPhoto = UITapGestureRecognizer(target: self, action: #selector(self.photo_TouchUpInside))
        
        //tapGestureForPhoto.cancelsTouchesInView = false
        
        photo.addGestureRecognizer(tapGestureForPhoto)
        photo.isUserInteractionEnabled = true
        
//        contentView.addGestureRecognizer(tapGestureForPhoto)
//        contentView.endEditing(true)
        
        //need to manage to select proper post on tableView
        //true to work with segue
        //false to get indexpath
    
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
          print("indexPath")
    }
    
  
    
    
    
    @objc func photo_TouchUpInside() {
        
        if let id = post!.uid {
          //  print("post!.uid: \(post!.uid)")
            delegateOfPhotoCollectionViewCell?.goToProfileTableVCFromProfileVC(userId: id)
            
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
