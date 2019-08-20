import UIKit

class HashTagViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var posts: [Post] = []
    var tag = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.dataSource = self
        collectionView.delegate = self
        loadPost()
    }
    
    func loadPost()  {
        Api.HashTagAPI.fetchPosts(withTag: tag) { (postId) in
            Api.PostAPI.observePost(withPostId: postId, completion: { (post) in
                self.posts.append(post)
                self.collectionView.reloadData()
            })
        }
    }
}

extension HashTagViewController: UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HashTagCollectionViewCell", for: indexPath) as! HashTagCollectionViewCell
        
        let post = posts[indexPath.row]
        
        cell.post = post
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("indexPath : \(indexPath)" )
    }
    
    //MARK: - cell size
    
    //delegation
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.size.width / 3  , height: collectionView.frame.size.width / 3  )
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return -2
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}

extension HashTagViewController : HashTagCollectionViewCellDelegate {
    func goToProfileTableVCFromHashTagVC(userId: String) {
        
        performSegue(withIdentifier: "HashTag_ProfileTable", sender: userId)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "HashTag_ProfileTable" {
            
            let profileTableVC = segue.destination as? ProfileTableViewController
            
            let userId = sender as? String
            
            profileTableVC!.userId = userId!
        }
    }
}

