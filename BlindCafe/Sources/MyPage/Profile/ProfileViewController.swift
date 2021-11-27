//
//  ProfileViewController.swift
//  BlindCafe
//
//  Created by 권하은 on 2021/11/21.
//

import UIKit

protocol regionProtocol {
    func passRegion(region: String, state: String)
}

class ProfileViewController: BaseViewController, regionProtocol {
    func passRegion(region: String, state: String) {
        regionButton.setTitle("\(region) \(state)", for: .normal)
    }
    
    @IBOutlet weak var userNicknameLabel: UILabel!
    @IBOutlet weak var userAgeLabel: UILabel!
    @IBOutlet weak var userGenderLabel: UILabel!
    
    @IBOutlet weak var nicknameView: UIView!
    @IBOutlet weak var nicknameAlert: UILabel!
    
    @IBOutlet weak var regionButton: UIButton!
    @IBAction func regionButton(_ sender: Any) {
        let vc = RegionChangeViewController()
        vc.delegate = self
        navigationController?.pushViewController(vc, animated: true)
    }
    
    
    var indexOfOneAndOnly: Int?
    @IBOutlet var partnerGenderButtons: [UIButton]!
    @IBAction func partnerGenderAction(_ sender: UIButton) {
        if indexOfOneAndOnly != nil {
            if !sender.isSelected {
                for index in partnerGenderButtons.indices {
                    partnerGenderButtons[index].isSelected = false
                }
                sender.isSelected = true
                indexOfOneAndOnly = partnerGenderButtons.firstIndex(of: sender)
                //reportNextButton.isEnabled = true
            }
            else {
                sender.isSelected = false
                indexOfOneAndOnly = nil
                //reportNextButton.isEnabled = false
            }
        }
        else {
            sender.isSelected = true
            indexOfOneAndOnly = partnerGenderButtons.firstIndex(of: sender)
            //reportNextButton.isEnabled = true
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setNavigation()
        nicknameView.backgroundColor = .white2
        nicknameAlert.textColor = .veryLightPink
        
        
        showIndicator()
        GetProfileDataManager().getProfile(viewController: self)
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

extension ProfileViewController {
    func getprofile(result: GetProfileResponse) {
        dismissIndicator()
        userNicknameLabel.text = result.nickname
        userAgeLabel.text = String(result.age)
        if result.myGender == "M" {
            userGenderLabel.text = "남자"
        } else {
            userGenderLabel.text = "여자"
        }
        
        if result.region != nil {
            regionButton.setTitle(result.region, for: .normal)
        }
        
        for index in partnerGenderButtons.indices {
            partnerGenderButtons[index].isSelected = false
        }
        if result.partnerGender == "F" {
            partnerGenderButtons[0].isSelected = true
        }
        else if result.partnerGender == "M" {
            partnerGenderButtons[1].isSelected = true
        }
        else {
            partnerGenderButtons[2].isSelected = true
        }
    }
}
