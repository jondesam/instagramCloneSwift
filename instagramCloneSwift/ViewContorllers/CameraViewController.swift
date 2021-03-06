import UIKit
import SVProgressHUD
import AVFoundation

class CameraViewController: UIViewController {
    
    @IBOutlet weak var photoToShare: UIImageView!
    @IBOutlet weak var photoDescription: UITextView!
    @IBOutlet weak var buttonShareOutlet: UIButton!
    
    var videoUrl: URL?
    var selectedImage: UIImage?
    var selectedImageUrl :Any? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.handleSelectProfileImageView))
        photoToShare.addGestureRecognizer(tapGesture)
        photoToShare.isUserInteractionEnabled = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        photoDescription.text = ""
        handlePost()
    }
    
    // MARK: - sharing button on and off
    func handlePost() {
        if selectedImage != nil {
            buttonShareOutlet.isEnabled = true
            buttonShareOutlet.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1)
        } else {
            buttonShareOutlet.isEnabled = false
            buttonShareOutlet.backgroundColor = .lightGray
        }
    }
    
    //MARK: - Image picker set up
    @objc func handleSelectProfileImageView () {
        
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.mediaTypes = ["public.movie","public.image"]
        
        present(imagePicker, animated: true, completion:nil)
    }
    
    //MARK: - Sharing Button
    @IBAction func buttonShare(_ sender: Any) {
        
        SVProgressHUD.show(withStatus: "Wait Please...")
        
        if let imageData = selectedImage!.jpegData(compressionQuality: 0.1){
            
            HelperService.uploadDataToServer(imageData: imageData,videoUrl: videoUrl ,description: photoDescription.text!, onSuccess: {
                
                self.photoDescription.text = ""
                self.tabBarController?.selectedIndex = 0
                SVProgressHUD.setMinimumDismissTimeInterval(1.0)
                SVProgressHUD.showSuccess(withStatus: "Success")
                
            }, onError: {
                
                SVProgressHUD.setMinimumDismissTimeInterval(1.0)
                SVProgressHUD.showError(withStatus: "Upload Failed")
                
            })
            
            SVProgressHUD.dismiss()
            photoToShare.image = UIImage(named: "placeholder.png")
            selectedImage = nil
        }
    }
    
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    
    
    func clean() {
        photoDescription.text = ""
        photoToShare.image = UIImage(named: "placeholder")
        selectedImage = nil
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "filter_segue" {
            
            let filterVC = segue.destination as! FilterViewController
            
            filterVC.selectedImage = self.selectedImage
            filterVC.delegateOfFilterViewController = self
            
        }
    }
}


extension CameraViewController : UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let videoUrl = info[.mediaURL] as? URL {
            
            if let thumbnailImage = thumbnailImageForFileUrl(videoUrl) {
                
                selectedImage = thumbnailImage
                
                photoToShare.image = thumbnailImage
                
                self.videoUrl = videoUrl
            }
            dismiss(animated: true, completion: nil)
        }
        
        
        if let image = info[.originalImage] as? UIImage {
            selectedImage = image
            photoToShare.image = image
            selectedImageUrl = info[.imageURL]
            dismiss(animated: true) {
            self.performSegue(withIdentifier: "filter_segue", sender: nil)
            }
        }
        
    }
    
    
    //making thumbnail photo
    func thumbnailImageForFileUrl(_ fileUrl: URL) -> UIImage? {
        
        let asset = AVAsset(url: fileUrl)
        
        let imageGeerator = AVAssetImageGenerator(asset: asset)
        
        do {
            //CMTimemake to capture image from video
            let thumbNailCGImage = try imageGeerator.copyCGImage(at: CMTimeMake(value: 6, timescale: 6), actualTime: nil)
            
            return UIImage(cgImage: thumbNailCGImage)
            
        } catch let err {
            print(err)
        }
        
        return nil
    }
    
}

extension CameraViewController : FilterViewControllerDelegate {
    func updatePhoto(image: UIImage) {
        
        self.photoToShare.image = image
        self.selectedImage = image
        
    }
}
