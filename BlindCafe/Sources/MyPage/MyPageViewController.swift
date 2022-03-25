//
//  MyPageViewController.swift
//  BlindCafe
//
//  Created by 권하은 on 2021/10/23.
//

import UIKit

protocol GetInfo {
    func passInfo()
}

class MyPageViewController: BaseViewController, GetInfo {
    func passInfo() {
        showIndicator()
        MyPageDataManager().requestMyPage(viewController: self)
    }

    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var genderLabel: UILabel!
    @IBOutlet weak var genderImageView: UIImageView!
    @IBOutlet weak var ageLabel: UILabel!
    @IBOutlet weak var regionLabel: UILabel!
    @IBOutlet weak var partnerGenderLabel: UILabel!
    
    @IBOutlet weak var interestImage1: UIImageView!
    @IBOutlet weak var interestImage2: UIImageView!
    @IBOutlet weak var interestImage3: UIImageView!
    
    @IBAction func profileImageChange(_ sender: Any) {
        let vc = ProfileImageViewController()
        vc.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func profileChange(_ sender: Any) {
        let vc = ProfileViewController()
        vc.hidesBottomBarWhenPushed = true
        vc.delegate = self
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func interestChange(_ sender: Any) {
        let vc = InterestChangeViewController()
        vc.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBOutlet weak var badgeCollectionView: UICollectionView!
    
    var drinksData: [Int] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = false
        navigationController?.navigationBar.barTintColor = .mainBlack
        setNavigation()
        
        badgeCollectionView.register(UINib(nibName: "BadgeCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "BadgeCollectionViewCell")
        badgeCollectionView.delegate = self
        badgeCollectionView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        showIndicator()
        MyPageDataManager().requestMyPage(viewController: self)
    }
    func setNavigation() {
        let titleview = UIView(frame: CGRect(x: 0, y: 10, width: 100, height: 22))
        let titleLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 100, height: 22))
        titleLabel.text = "마이페이지"
        titleLabel.font = .SpoqaSans(.bold, size: 16)
        titleLabel.textColor = .white2
        titleLabel.textAlignment = .center
        //navigationController?.navigationBar.addSubview(titleLabel)
        titleview.addSubview(titleLabel)
        navigationController?.navigationBar.topItem?.titleView = titleview
        
        let backButton: UIButton = UIButton()
        backButton.setImage(UIImage(named: "settingsbutton"), for: .normal)
        backButton.addTarget(self, action: #selector(toSetting), for: .touchUpInside)
        backButton.frame = CGRect(x: 0, y: 0, width: 44, height: 44)
        let addBackButton = UIBarButtonItem(customView: backButton)
        self.navigationItem.rightBarButtonItem = addBackButton
    }
    
    @objc func toSetting() {
        let vc = SettingsViewController()
        vc.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension MyPageViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 9
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BadgeCollectionViewCell", for: indexPath) as! BadgeCollectionViewCell
        
        cell.badgeImageView.image = UIImage(named: "badge")
        
        if drinksData.count != 0 {
            for i in 0...(drinksData.count - 1) {
                if indexPath.row == (drinksData[i] - 1) {
                    cell.badgeImageView.image = UIImage(named: drinkName(name: drinksData[i]))
                }
            }
        }
        return cell
    }
    
    
}

extension MyPageViewController {
    func request(result: MyPageResponse) {
        dismissIndicator()
        if result.profileImage != nil {
            let url = URL(string: result.profileImage!)
            let data = try? Data(contentsOf: url!)
            profileImage.image = UIImage(data: data!)
        } else {
            profileImage.image = UIImage(named: "profileimagedefault")
        }
        
        drinksData = result.drinks
        badgeCollectionView.reloadData()
        print(drinksData)
        
        nameLabel.text = result.nickname
        if result.myGender == "M" {
            genderLabel.text = "남자"
            genderImageView.image = UIImage(named: "mypagemale")
        }
        else {
            genderLabel.text = "여자"
            genderImageView.image = UIImage(named: "mypagefemale")
        }
        ageLabel.text = String(result.age)
        
        let region = result.region
        if region == nil || region == "  " {
            regionLabel.text = "지역을 설정해주세요"
            regionLabel.textColor = .veryLightPink
        } else {
            regionLabel.text = result.region
            regionLabel.textColor = .white2
        }
        
        if result.partnerGender == "M" {
            partnerGenderLabel.text = "남자"
        } else if result.partnerGender == "F" {
            partnerGenderLabel.text = "여자"
        } else {
            partnerGenderLabel.text = "상관없음"
        }
        
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
            nameString = "myjob"
        case 2:
            nameString = "myanimation"
        case 3:
            nameString = "myanimal"
        case 4:
            nameString = "myfood"
        case 5:
            nameString = "mytravel"
        case 6:
            nameString = "mygame"
        case 7:
            nameString = "myentertainment"
        case 8:
            nameString = "mysports"
        case 9:
            nameString = "myfinancial"
        default:
            break
        }
        return nameString
    }
    
    func drinkName(name: Int) -> String {
        var drinkName = ""
        switch name {
        case 1:
            drinkName = "americanobadge"
        case 2:
            drinkName = "cafelattebadge"
        case 3:
            drinkName = "cafemochabadge"
        case 4:
            drinkName = "bubbleteabadge"
        case 5:
            drinkName = "mintchocolatebadge"
        case 6:
            drinkName = "strawberrybadge"
        case 7:
            drinkName = "bluelemonadebadge"
        case 8:
            drinkName = "greenteabadge"
        case 9:
            drinkName = "grapefruitbadge"
        default:
            break
        }
        return drinkName
    }
}
