//
//  ProfileImageViewController.swift
//  BlindCafe
//
//  Created by 권하은 on 2021/11/27.
//

import UIKit

class ProfileImageViewController: BaseViewController {
    @IBOutlet weak var profileImage1: UIImageView!
    @IBOutlet weak var profileButton1: UIButton!
    @IBAction func profileButton1(_ sender: UIButton) {
        let vc = ProfilePhotoViewController()
        vc.selectedfield = 1
        vc.modalPresentationStyle = .pageSheet
        present(vc, animated: true, completion: nil)
    }
    
    @IBOutlet weak var profileImage2: UIImageView!
    @IBOutlet weak var profileButton2: UIButton!
    @IBAction func profileButton2(_ sender: Any) {
        let vc = ProfilePhotoViewController()
        vc.selectedfield = 2
        vc.modalPresentationStyle = .pageSheet
        present(vc, animated: true, completion: nil)
    }
    
    @IBOutlet weak var profileImage3: UIImageView!
    @IBOutlet weak var profileButton3: UIButton!
    @IBAction func profileButton3(_ sender: Any) {
        let vc = ProfilePhotoViewController()
        vc.selectedfield = 3
        vc.modalPresentationStyle = .pageSheet
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
    }

}
