//
//  ProfileViewController.swift
//  BlindCafe
//
//  Created by 권하은 on 2021/11/21.
//

import UIKit

class ProfileViewController: BaseViewController {

    @IBOutlet weak var profileImage1: UIImageView!
    @IBOutlet weak var profileButton1: UIButton!
    @IBAction func profileButton1(_ sender: UIButton) {
    }
    
    @IBOutlet weak var profileImage2: UIImageView!
    @IBOutlet weak var profileButton2: UIButton!
    @IBAction func profileButton2(_ sender: Any) {
    }
    
    @IBOutlet weak var profileImage3: UIImageView!
    @IBOutlet weak var profileButton3: UIButton!
    @IBAction func profileButton3(_ sender: Any) {
    }
    
    @IBOutlet weak var userAgeLabel: UILabel!
    @IBOutlet weak var userGenderLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setNavigation()
    }
    
    func setNavigation() {
        let backButton: UIButton = UIButton()
        backButton.setImage(UIImage(named: "backbutton"), for: .normal)
        backButton.addTarget(self, action: #selector(popToVC), for: .touchUpInside)
        backButton.frame = CGRect(x: 18, y: 0, width: 44, height: 44)
        let addBackButton = UIBarButtonItem(customView: backButton)
        
        self.navigationItem.setLeftBarButton(addBackButton, animated: false)
        
        let titleview = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 44))
        let titleLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 100, height: 44))
        titleLabel.text = "프로필 수정"
        titleLabel.font = .SpoqaSans(.bold, size: 16)
        titleLabel.textColor = .white2
        titleLabel.textAlignment = .center
        titleview.addSubview(titleLabel)
        self.navigationItem.titleView = titleview
    }

}
