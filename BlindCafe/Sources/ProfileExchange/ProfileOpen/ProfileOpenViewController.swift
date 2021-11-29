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
            showIndicator()
            ProfileOpenDataManager().getProfile(id: UserDefaults.standard.integer(forKey: "MatchingId"), viewController: self)
            
            if fill {
                let strArr = regionButton.title(for: .normal)!.split(separator: " ")
                UserDefaults.standard.set(nicknameTextField.text, forKey: "UserNickname")
                showIndicator()
                let input = PostProfileInput(nickname: nicknameTextField.text!, state: String(strArr[0]), region: String(strArr[1]))
                PostProfileDataManager().putProfile(input, id: UserDefaults.standard.integer(forKey: "MatchingId"), viewController: self)
            } else {
                self.presentBottomAlert(name: "profilefirst")
            }
        }
        
    }
    
    var fill: Bool!
    override func viewDidLoad() {
        super.viewDidLoad()

        showIndicator()
        ProfileOpenDataManager().getProfile(id: UserDefaults.standard.integer(forKey: "MatchingId"), viewController: self)
    }
}

extension ProfileOpenViewController {
    func getprofile(result: ProfileOpenResponse) {
        dismissIndicator()
        openLabel1.text = "72시간의 대화가 종료되었습니다.\n그 동안 \(result.partnerNickname)님과의 만남이 즐거우셨나요?"
        openLabel2.text = "내 프로필을 멋지게 채우고 \(result.partnerNickname)님의 프로필을 받아보세요!"
        
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
        
        regionButton.setTitle(result.region, for: .normal)
        
        
        interestButtons[0].setImage(getInterestImage(id: result.interests[0]), for: .normal)
        interestButtons[1].setImage(getInterestImage(id: result.interests[1]), for: .normal)
        interestButtons[2].setImage(getInterestImage(id: result.interests[2]), for: .normal)
        
        fill = result.fill
    }
    
    func postprofile(result: PostProfileResponse) {
        dismissIndicator()
    }
    
    func getInterestImage(id: String) -> UIImage {
        var interestImage = UIImage()
        switch id {
        case "1":
            interestImage = UIImage(named: "exjob")!
        case "2":
            interestImage = UIImage(named: "exanimation")!
        case "3":
            interestImage = UIImage(named: "exanimal")!
        case "4":
            interestImage = UIImage(named: "exfood")!
        case "5":
            interestImage = UIImage(named: "extravel")!
        case "6":
            interestImage = UIImage(named: "exgame")!
        case "7":
            interestImage = UIImage(named: "exentertainment")!
        case "8":
            interestImage = UIImage(named: "exsports")!
        case "9":
            interestImage = UIImage(named: "exfinancial")!
        default:
            break
        }
        
        return interestImage
    }
}
