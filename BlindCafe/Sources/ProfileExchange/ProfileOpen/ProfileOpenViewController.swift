//
//  ProfileOpenViewController.swift
//  BlindCafe
//
//  Created by 권하은 on 2021/11/29.
//

import UIKit

class ProfileOpenViewController: BaseViewController, regionProtocol {
    func passRegion(region: String, state: String) {
        regionButton.setTitle("\(region) \(state)", for: .normal)
    }
    
    @IBOutlet weak var openLabel1: UILabel!
    @IBOutlet weak var openLabel2: UILabel!
    @IBOutlet weak var openLabel3: UILabel!
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBAction func cameraButton(_ sender: Any) {
        let vc = ProfileImageViewController()
        vc.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBOutlet weak var nicknameTextField: UITextField!
    @IBOutlet weak var nicknameView: UIView!
    @IBOutlet weak var nicknameAlert: UILabel!
    
    @IBOutlet weak var ageLabel: UILabel!
    @IBOutlet weak var genderLabel: UILabel!
    
    @IBOutlet weak var regionButton: UIButton!
    @IBAction func regionButton(_ sender: Any) {
        let vc = RegionChangeViewController()
        vc.delegate = self
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBOutlet var interestButtons: [UIButton]!
    
    @IBOutlet weak var openButton: UIButton!
    @IBAction func openButton(_ sender: Any) {
        let count = nicknameTextField.text?.count ?? 0
        
        if count < 1 || count > 9 {
            nicknameAlert.textColor = .coral
            nicknameView.backgroundColor = .coral
        }
        else {
            if profileImageView.image != UIImage(named: "profileimagedefault") && regionButton.title(for: .normal) != "지역을 설정해주세요" {
                let strArr = regionButton.title(for: .normal)!.split(separator: " ")
                UserDefaults.standard.set(nicknameTextField.text, forKey: "UserNickname")
                showIndicator()
                let input = PostProfileInput(nickname: nicknameTextField.text!, state: String(strArr[0]), region: String(strArr[1]))
                print(input)
                PostProfileDataManager().putProfile(input, id: UserDefaults.standard.integer(forKey: "MatchingId"), viewController: self)
            } else {
                self.presentBottomAlert(name: "profilefirst")
            }
        }
    }
    
    var fill: Bool!
    override func viewDidLoad() {
        super.viewDidLoad()
        nicknameView.backgroundColor = .white2
        nicknameAlert.textColor = .veryLightPink
        setNavigation()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        showIndicator()
        ProfileOpenDataManager().getProfile(id: UserDefaults.standard.integer(forKey: "MatchingId"), viewController: self)
    }
    
    func setNavigation() {
        let backButton: UIButton = UIButton()
        backButton.setImage(UIImage(named: "backbutton"), for: .normal)
        backButton.addTarget(self, action: #selector(popToRoot), for: .touchUpInside)
        backButton.frame = CGRect(x: 18, y: 0, width: 44, height: 44)
        let addBackButton = UIBarButtonItem(customView: backButton)
        
        self.navigationItem.setLeftBarButton(addBackButton, animated: false)
        
        let titleview = UIView(frame: CGRect(x: 0, y: 0, width: 120, height: 44))
        let titleLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 120, height: 44))
        titleLabel.text = "프로필 공개하기"
        titleLabel.font = .SpoqaSans(.bold, size: 16)
        titleLabel.textColor = .white2
        titleLabel.textAlignment = .center
        titleview.addSubview(titleLabel)
        self.navigationItem.titleView = titleview
        
        dismissKeyboardWhenTappedAround()
    }
    
    @objc func popToRoot() {
        navigationController?.popToRootViewController(animated: false)
    }
    
    @IBAction func textChange(_ sender: Any) {
        nicknameAlert.textColor = .veryLightPink
        nicknameView.backgroundColor = .white2
    }
}

extension ProfileOpenViewController {
    func getprofile(result: ProfileOpenResponse) {
        dismissIndicator()
        openLabel1.text = "72시간의 대화가 종료되었습니다.\n그 동안 \(result.partnerNickname)님과의 만남이 즐거우셨나요?"
        openLabel2.text = "내 프로필을 멋지게 채우고 \(result.partnerNickname)님의 프로필을 받아보세요!"
        openLabel3.text = "7시간 뒤 자동으로 프로필이 발송됩니다.\n프로필이 완성될수록 \(result.partnerNickname)님과 대화할 수 있는 기능이 높아져요!"
        
        if result.profileImage != nil {
            let url = URL(string: result.profileImage!)
            let data = try? Data(contentsOf: url!)
            profileImageView.image = UIImage(data: data!)
        }
        
        nicknameTextField.text = result.nickname
        ageLabel.text = String(result.age)
        
        if result.gender == "F" {
            genderLabel.text = "여자"
        } else {
            genderLabel.text = "남자"
        }
        
        if result.region != nil {
            regionButton.setTitle(result.region, for: .normal)
        }
        
        
        interestButtons[0].setImage(getInterestImage(id: result.interests[0]), for: .normal)
        interestButtons[1].setImage(getInterestImage(id: result.interests[1]), for: .normal)
        interestButtons[2].setImage(getInterestImage(id: result.interests[2]), for: .normal)
        
        fill = result.fill
        
        
        
        if fill {
            openButton.isSelected = true
        } else {
            openButton.isSelected = false
        }
        
        
    }
    
    func postprofile(result: PostProfileResponse) {
        dismissIndicator()
        if result.result == false {
            let vc = WaitProfileViewController()
            vc.partnerName = result.nickname
            navigationController?.pushViewController(vc, animated: true)
        }
        else {
            showIndicator()
            GetNextDataManager().getPartnerProfile(id: UserDefaults.standard.integer(forKey: "MatchingId"), viewController: self)
        }
    }
    
    func getPartner(result: GetPartnerProfileResponse) {
        dismissIndicator()
        if result.fill == false {
            let vc = WaitProfileViewController()
            vc.partnerName = result.nickname
            navigationController?.pushViewController(vc, animated: true)
        } else {
            let vc = ProfileAcceptViewController()
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func getInterestImage(id: String) -> UIImage {
        var interestImage = UIImage()
        switch id {
        case "취업":
            interestImage = UIImage(named: "exjob")!
        case "작품":
            interestImage = UIImage(named: "exanimation")!
        case "동물":
            interestImage = UIImage(named: "exanimal")!
        case "음식":
            interestImage = UIImage(named: "exfood")!
        case "여행":
            interestImage = UIImage(named: "extravel")!
        case "게임":
            interestImage = UIImage(named: "exgame")!
        case "연예":
            interestImage = UIImage(named: "exentertainment")!
        case "스포츠":
            interestImage = UIImage(named: "exsports")!
        case "재테크":
            interestImage = UIImage(named: "exfinancial")!
        default:
            break
        }
        
        return interestImage
    }
}
