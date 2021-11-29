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
        switch selectedField {
        case 1:
            profileImages[0].image = profileImage
        case 2:
            profileImages[1].image = profileImage
        case 3:
            profileImages[2].image = profileImage
        default:
            print("uploaded!")
        }
        
    }
    
    @IBOutlet var profileImages: [UIImageView]!
    @IBOutlet var profileButtons: [UIButton]!
    @IBAction func profileButton1(_ sender: UIButton) {
        if !sender.isSelected {
            let vc = ProfilePhotoViewController()
            vc.selectedfield = 1
            vc.modalPresentationStyle = .pageSheet
            vc.delegate = self
            present(vc, animated: true, completion: nil)
        } else {
            
        }
        
    }
    
    @IBAction func profileButton2(_ sender: Any) {
        let vc = ProfilePhotoViewController()
        vc.selectedfield = 2
        vc.modalPresentationStyle = .pageSheet
        vc.delegate = self
        present(vc, animated: true, completion: nil)
    }
    
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
    func getImages(result: GetProfileImageResponse) {
        dismissIndicator()
        for i in 0...2 {
            if result.images![i] != "" {
                let url = URL(string: result.images![i])
                let data = try? Data(contentsOf: url!)
                profileImages[i].image = UIImage(data: data!)
                profileButtons[i].isSelected = true
            }
            else {
                profileImages[i].image = UIImage(named: "profileimagefield")
                profileButtons[i].isSelected = false
            }
        }
        
    }
}
