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
    
    var delegate: GetInfo?
    
    @IBOutlet weak var userNicknameTextField: UITextField!
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
    
    @IBOutlet var partnerGenderButtons: [UIButton]!
    @IBAction func partnerGenderAction(_ sender: UIButton) {
        if !sender.isSelected {
            for index in partnerGenderButtons.indices {
                partnerGenderButtons[index].isSelected = false
            }
            sender.isSelected = true
        }
    }
    
    @IBAction func textFieldChanged(_ sender: Any) {
        nicknameAlert.textColor = .veryLightPink
        nicknameView.backgroundColor = .white2
    }
    
    @IBAction func changeButton(_ sender: Any) {
        let count = userNicknameTextField.text?.count ?? 0
        
        if count < 1 || count > 9 {
            nicknameAlert.textColor = .coral
            nicknameView.backgroundColor = .coral
        }
        else {
            UserDefaults.standard.set(userNicknameTextField.text, forKey: "UserNickname")
            var partnerGender = ""
            if partnerGenderButtons[0].isSelected {
                partnerGender = "F"
            } else if partnerGenderButtons[1].isSelected {
                partnerGender = "M"
            } else {
                partnerGender = "N"
            }
            
            if regionButton.title(for: .normal) != "지역을 설정해주세요" {
                let stateArr = regionButton.title(for: .normal)?.split(separator: " ")
                let input = PutProfileInput(nickname: userNicknameTextField.text!, partnerGender: partnerGender, state: String(stateArr![0]), region: String(stateArr![1]))
                PutProfileDataManager().putProfile(input, viewController: self)
            } else {
                let input = PutProfileInput(nickname: userNicknameTextField.text!, partnerGender: partnerGender, state: nil, region: nil)
                PutProfileDataManager().putProfile(input, viewController: self)
            }
            
            delegate?.passInfo()
            navigationController?.popViewController(animated: false)
            
        }

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setNavigation()
        nicknameView.backgroundColor = .white2
        nicknameAlert.textColor = .veryLightPink
        dismissKeyboardWhenTappedAround()
        
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
        userNicknameTextField.text = result.nickname
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
    
    func putprofile(result: PutProfileResponse) {
        dismissIndicator()
        
    }
}
