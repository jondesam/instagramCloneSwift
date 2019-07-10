//
//  FilerViewController.swift
//  instagramCloneSwift
//
//  Created by MyMac on 2019-07-06.
//  Copyright © 2019 Apex. All rights reserved.
//

import UIKit

protocol FilterViewControllerDelegate {
    func updatePhoto(image: UIImage)
}


class FilterViewController: UIViewController {
    
    @IBAction func cancel_Btn(_ sender: UIButton) {
      
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func next_Btn(_ sender: UIButton) {
    
        dismiss(animated: true, completion: nil)
        delegateOfFilterViewController?.updatePhoto(image: self.filterPhoto.image!)
    }
    
    
    @IBOutlet weak var filterPhoto: UIImageView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var selectedImage: UIImage!
    var delegateOfFilterViewController : FilterViewControllerDelegate?
    let context = CIContext(options: nil)
    
    var CIFilterNames = ["CIPhotoEffectMono","CIPhotoEffectInstant","CIPhotoEffectFade","CIPhotoEffectChrome","CIFalseColor","CIPhotoEffectTransfer","CIColorCubeWithColorSpace","CIColorMonochrome","CIColorPosterize","CIPhotoEffectNoir","CIPhotoEffectProcess","CIPhotoEffectTonal","CISepiaTone","CIVignetteEffect"]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
     filterPhoto.image = selectedImage
    }
    
    func resizeImage(image: UIImage, newWidth: CGFloat) -> UIImage {
        
        let scale = newWidth / image.size.width
        let newHeight = image.size.height * scale
        
        UIGraphicsBeginImageContext(CGSize(width: newWidth, height: newHeight))
        image.draw(in: CGRect(x: 0, y: 0, width: newWidth, height: newHeight))
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
}


extension FilterViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
      //  print("countOfArray: \(CIFilterNames.count)")
        
        return CIFilterNames.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FilterCollectionViewCell", for: indexPath) as! FilterCollectionViewCell
        
        let resizedImage = resizeImage(image: selectedImage, newWidth: 150)
      
        
        //print(resizedImage.size)
        
        //cell.filterPreview.image = selectedImage
        
        let ciImage = CIImage(image: resizedImage)
        let filter = CIFilter(name: CIFilterNames[indexPath.item])
        
        filter?.setValue(ciImage, forKey: kCIInputImageKey)
        
        if let filteredImage = filter?.value(forKey: kCIOutputImageKey) as? CIImage {
            let result = context.createCGImage(filteredImage, from: filteredImage.extent)
            
            //cell.filterPreview.image = UIImage(ciImage: filteredmage)
            cell.filterPreview.image = UIImage(cgImage: result!)
        }
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        print("indexPath : \(indexPath)")
       // let resizedImage = resizeImage(image: selectedImage, newWidth: 150)
        let ciImage = CIImage(image: selectedImage)
        let filter = CIFilter(name: CIFilterNames[indexPath.item])
        
        filter?.setValue(ciImage, forKey: kCIInputImageKey)
        
        if let filteredImage = filter?.value(forKey: kCIOutputImageKey) as? CIImage {
            let result = context.createCGImage(filteredImage, from: filteredImage.extent)
            self.filterPhoto.image = UIImage(cgImage: result!)
        }
    }
    
    
}
