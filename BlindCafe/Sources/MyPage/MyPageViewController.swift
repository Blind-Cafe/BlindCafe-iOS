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
        navigationController?.pushViewController(SettingsViewController(), animated: true)
    }
}

extension MyPageViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 9
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BadgeCollectionViewCell", for: indexPath) as! BadgeCollectionViewCell
        
        let count = drinksData.count
        
        if indexPath.row < count {
            cell.badgeImageView.image = UIImage(named: drinkName(name: drinksData[indexPath.row]))
        }
        else {
            cell.badgeImageView.image = UIImage(named: "badge")
        }
        
        return cell
    }
    
    
}

extension MyPageViewController {
    func request(result: MyPageResponse) {
        dismissIndicator()
        drinksData = result.drinks
        
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
            drinkName = "grapefruitteabadge"
        default:
            break
        }
        return drinkName
    }
}
