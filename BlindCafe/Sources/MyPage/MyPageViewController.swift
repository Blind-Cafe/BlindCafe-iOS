//
//  MyPageViewController.swift
//  BlindCafe
//
//  Created by 권하은 on 2021/10/23.
//

import UIKit

class MyPageViewController: BaseViewController {

    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var genderLabel: UILabel!
    @IBOutlet weak var ageLabel: UILabel!
    @IBOutlet weak var regionLabel: UILabel!
    
    @IBOutlet weak var interestImage1: UIImageView!
    @IBOutlet weak var interestImage2: UIImageView!
    @IBOutlet weak var interestImage3: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = false
        setNavigation()
        
        showIndicator()
        MyPageDataManager().requestMyPage(viewController: self)
    }
    
    func setNavigation() {
        let titleLabel = UILabel(frame: CGRect(x: 25, y: 10, width: 100, height: 22))
        titleLabel.text = "마이페이지"
        titleLabel.font = .SpoqaSans(.bold, size: 15)
        titleLabel.textColor = .white2
        navigationController?.navigationBar.addSubview(titleLabel)
        
        let backButton: UIButton = UIButton()
        backButton.setImage(UIImage(named: "settingsbutton"), for: .normal)
        backButton.addTarget(self, action: #selector(toSetting), for: .touchUpInside)
        backButton.frame = CGRect(x: 0, y: 0, width: 44, height: 44)
        let addBackButton = UIBarButtonItem(customView: backButton)
        self.navigationItem.rightBarButtonItem = addBackButton
    }
    
    @objc func toSetting() {
        
    }
}

extension MyPageViewController {
    func request(result: MyPageResponse) {
        dismissIndicator()
        nameLabel.text = result.nickname
        if result.myGender == "M" {
            genderLabel.text = "남자"
        }
        else {
            genderLabel.text = "여자"
        }
        ageLabel.text = String(result.age)
        regionLabel.text = result.region ?? ""
        
        interestImage1.image = UIImage(named: mainName(name: result.interests[0]))
        interestImage2.image = UIImage(named: mainName(name: result.interests[1]))
        interestImage3.image = UIImage(named: mainName(name: result.interests[2]))
    }
    
    func failedToRequest(message: String) {
        dismissIndicator()
        presentAlert(message: message)
    }
    
    func mainName(name: Int) -> String {
        var nameString = ""
        switch name {
        case 1:
            nameString = "myfood"
        case 2:
            nameString = "mytravel"
        case 3:
            nameString = "mygame"
        case 4:
            nameString = "myentertainment"
        case 5:
            nameString = "mysports"
        case 6:
            nameString = "myfinancial"
        case 7:
            nameString = "myjob"
        case 8:
            nameString = "myanimation"
        case 9:
            nameString = "myanimal"
        default:
            break
        }
        return nameString
    }
}
