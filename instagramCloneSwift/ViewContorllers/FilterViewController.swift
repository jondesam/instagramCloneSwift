//
//  FilerViewController.swift
//  instagramCloneSwift
//
//  Created by MyMac on 2019-07-06.
//  Copyright © 2019 Apex. All rights reserved.
//

import UIKit

class FilterViewController: UIViewController {

    @IBAction func cancelButton(_ sender: Any) {
    }
    
    @IBAction func nextButton(_ sender: Any) {
    }
    
    
    @IBOutlet weak var filterPhoto: UIImageView!
    
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    
    
}

extension FilterViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FilterCollectionViewCell", for: indexPath) as! FilterCollectionViewCell
        
        return cell
    }
    
    
    
}
