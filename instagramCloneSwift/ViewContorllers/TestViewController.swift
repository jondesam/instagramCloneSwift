import UIKit

class TestViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var selectedImage:UIImage!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
}


extension TestViewController: UICollectionViewDelegate,UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TestCollectionViewCell", for: indexPath) as! TestCollectionViewCell
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("indexPath \(indexPath)")
    }
    
}
