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

    imageView.sd_setImage(with: photoUrl)
    }
    
    let tapGestureForPhoto = UITapGestureRecognizer(target: self, action: #selector(self.photo_TouchUpInside))
        
        tapGestureForPhoto.cancelsTouchesInView = false
        
        imageView.addGestureRecognizer(tapGestureForPhoto)
        
        imageView.isUserInteractionEnabled = true
    
    }
    
    @objc func photo_TouchUpInside() {
        
        if let id = post!.uid {

            delegateOfHashTagCollectionViewCell?.goToProfileTableVCFromHashTagVC(userId: id)
            
        }
    }
}
