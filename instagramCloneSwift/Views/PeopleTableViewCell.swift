import UIKit
import Foundation

protocol PeopleTableViewCellDelegate {
    
    func goToProfileUserVC(userId: String)
}

class PeopleTableViewCell: UITableViewCell {
    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var followButton: UIButton!
    
    var delegateOfPeopleTableViewCell:
    PeopleTableViewCellDelegate?
    
    var userInCell: UserModel?{
        didSet{
            setUpUserInfo()
        }
    }
    
    func setUpUserInfo() {
        
        profileImage.layer.masksToBounds = false
        profileImage.layer.borderColor = UIColor.white.cgColor
        profileImage.layer.cornerRadius =  profileImage.frame.height/2
        profileImage.clipsToBounds = true
        
        
        if let user = userInCell{
            self.nameLabel.text = user.username
            
            if let photoUrlString = user.profileImageUrl {
                let photoUrl = URL(string: photoUrlString)
                
                profileImage.sd_setImage(with: photoUrl,placeholderImage:UIImage(named:
                    "placeholderImg.jpeg") )
                
            }
        }
        
        if userInCell!.isFollowed! == true {
            configureUnfollowButton()
            
        } else {
            configureFollowButton()
        }
    }
    
    
    func configureFollowButton(){
        followButton.layer.borderWidth = 1
        followButton.layer.borderColor = UIColor(red: 226/255, green: 228/255, blue: 232/255, alpha:1).cgColor
        followButton.layer.cornerRadius = 5
        followButton.backgroundColor = UIColor(red: 69/255, green: 142/255, blue: 255/255, alpha: 1)
        followButton.setTitleColor(UIColor.white, for: UIControl.State.normal)
        followButton.setTitle("follow", for: UIControl.State.normal)
        followButton.addTarget(self, action: #selector(self.followAction), for: UIControl.Event.touchUpInside)
        
    }
    
    func configureUnfollowButton(){
        
        followButton.layer.borderWidth = 1
        followButton.layer.borderColor = UIColor(red: 226/255, green: 228/255, blue: 232/255, alpha:1).cgColor
        followButton.layer.cornerRadius = 5
        followButton.clipsToBounds = true
        followButton.setTitleColor(UIColor.black, for: UIControl.State.normal)
        followButton.backgroundColor = UIColor.clear
        followButton.setTitle("following", for: UIControl.State.normal)
        followButton.addTarget(self, action: #selector(self.unFollowAction), for: UIControl.Event.touchUpInside)
    }
    
    
    @objc func followAction()  {
        
        if userInCell!.isFollowed! == false {
            Api.FollowAPI.followAction(idInCell: userInCell!.id!)
            
            // to allow button have 2 ways both follow and Unfollow
            configureUnfollowButton()
            userInCell!.isFollowed! = true
        }
        
        /*before updatng cell directly
         // this causes haavy duty on view
         Api.FollowAPI.followAction(idInCell: userInCell!.id!)
         
         // to allow button have 2 ways both follow and Unfollow
         configureUnfollowButton()
         */
    }
    
    @objc func unFollowAction() {
        if userInCell!.isFollowed! == true {
            Api.FollowAPI.unFollowAction(withUser: userInCell!.id!)
            
            // to make button have 2 ways both follow and Unfollow
            configureFollowButton()
            userInCell!.isFollowed! = false
        }
        
        /*before updatng cell directly
         // this causes haavy duty on view
         Api.FollowAPI.unFollowAction(withUser: userInCell!.id!)
         
         // to make button have 2 ways both follow and Unfollow
         configureFollowButton()
         */
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        //Aloow user to touch imageView as button
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.nameLabel_TouchUpInside))
        
        nameLabel.addGestureRecognizer(tapGesture)
        nameLabel.isUserInteractionEnabled = true
        
    }
    
    @objc func nameLabel_TouchUpInside() {
        if let id = userInCell!.id {
            
            delegateOfPeopleTableViewCell?.goToProfileUserVC(userId: id)
            
        }
    }
    
}
