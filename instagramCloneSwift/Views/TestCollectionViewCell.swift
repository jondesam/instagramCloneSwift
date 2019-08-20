import UIKit

class TestCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var testImage: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        testImage.image = UIImage(named: "discover")
        
    }
}
