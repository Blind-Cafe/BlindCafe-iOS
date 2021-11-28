//
//  ProfileImageViewController.swift
//  BlindCafe
//
//  Created by 권하은 on 2021/11/27.
//

import UIKit

protocol GetImage {
    func getImage(selectedField: Int, profileImage: UIImage)
}

class ProfileImageViewController: BaseViewController, GetImage {
    func getImage(selectedField: Int, profileImage: UIImage){
        /*switch selectedField {
        case 1:
            profileImage1.image = profileImage
        case 2:
            profileImage2.image = profileImage
        case 3:
            profileImage3.image = profileImage
        default:
            print("uploaded!")
        }*/
        
        showIndicator()
        GetProfileImageDataManager().getProfileImage(viewController: self)
    }
    
    @IBOutlet weak var profileImage1: UIImageView!
    @IBOutlet weak var profileButton1: UIButton!
    @IBAction func profileButton1(_ sender: UIButton) {
        let vc = ProfilePhotoViewController()
        vc.selectedfield = 1
        vc.modalPresentationStyle = .pageSheet
        vc.delegate = self
        present(vc, animated: true, completion: nil)
    }
    
    @IBOutlet weak var profileImage2: UIImageView!
    @IBOutlet weak var profileButton2: UIButton!
    @IBAction func profileButton2(_ sender: Any) {
        let vc = ProfilePhotoViewController()
        vc.selectedfield = 2
        vc.modalPresentationStyle = .pageSheet
        vc.delegate = self
        present(vc, animated: true, completion: nil)
    }
    
    @IBOutlet weak var profileImage3: UIImageView!
    @IBOutlet weak var profileButton3: UIButton!
    @IBAction func profileButton3(_ sender: Any) {
        let vc = ProfilePhotoViewController()
        vc.selectedfield = 3
        vc.modalPresentationStyle = .pageSheet
        vc.delegate = self
        present(vc, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let backButton: UIButton = UIButton()
        backButton.setImage(UIImage(named: "backbutton"), for: .normal)
        backButton.addTarget(self, action: #selector(popToVC), for: .touchUpInside)
        backButton.frame = CGRect(x: 18, y: 0, width: 44, height: 44)
        let addBackButton = UIBarButtonItem(customView: backButton)
        
        self.navigationItem.setLeftBarButton(addBackButton, animated: false)
        
        let titleview = UIView(frame: CGRect(x: 0, y: 0, width: 120, height: 44))
        let titleLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 120, height: 44))
        titleLabel.text = "프로필 사진 수정"
        titleLabel.font = .SpoqaSans(.bold, size: 16)
        titleLabel.textColor = .white2
        titleLabel.textAlignment = .center
        titleview.addSubview(titleLabel)
        self.navigationItem.titleView = titleview
    
        showIndicator()
        GetProfileImageDataManager().getProfileImage(viewController: self)
    }

}

extension ProfileImageViewController {
    func getImages(result: GetProfileResponse) {
        dismissIndicator()
        if result.images != nil {
            if result.images!.count == 3 {
                let url = URL(string: result.images![0])
                let data = try? Data(contentsOf: url!)
                profileImage1.image = UIImage(data: data!)
                profileButton1.isSelected = true
                
                let url2 = URL(string: result.images![1])
                let data2 = try? Data(contentsOf: url2!)
                profileImage2.image = UIImage(data: data2!)
                profileButton2.isSelected = true
                
                let url3 = URL(string: result.images![2])
                let data3 = try? Data(contentsOf: url3!)
                profileImage3.image = UIImage(data: data3!)
                profileButton3.isSelected = true
            }
            else if result.images!.count == 2 {
                let url = URL(string: result.images![0])
                let data = try? Data(contentsOf: url!)
                profileImage1.image = UIImage(data: data!)
                profileButton1.isSelected = true
                
                let url2 = URL(string: result.images![1])
                let data2 = try? Data(contentsOf: url2!)
                profileImage2.image = UIImage(data: data2!)
                profileButton2.isSelected = true
                
                profileImage3.image = UIImage(named: "profileimagefield")
                profileButton3.isSelected = false
            }
            else if result.images!.count == 1 {
                let url = URL(string: result.images![0])
                let data = try? Data(contentsOf: url!)
                profileImage1.image = UIImage(data: data!)
                profileButton1.isSelected = true
                
                profileImage2.image = UIImage(named: "profileimagefield")
                profileButton2.isSelected = false
                
                profileImage3.image = UIImage(named: "profileimagefield")
                profileButton3.isSelected = false
            }
        }
        
    }
}
