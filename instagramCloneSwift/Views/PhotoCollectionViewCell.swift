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
            photo!.sd_setImage(with: photoUrl)
        }

        let tapGestureForPhoto = UITapGestureRecognizer(target: self, action: #selector(self.photo_TouchUpInside))
    
        photo.addGestureRecognizer(tapGestureForPhoto)
        photo.isUserInteractionEnabled = true
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

    }
    
    
    @objc func photo_TouchUpInside() {
        
        if let id = post!.uid {
    
            delegateOfPhotoCollectionViewCell?.goToProfileTableVCFromProfileVC(userId: id)
            
        }
    }
}

