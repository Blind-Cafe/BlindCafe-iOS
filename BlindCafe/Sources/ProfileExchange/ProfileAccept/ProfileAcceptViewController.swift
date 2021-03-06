//
//  ProfileAcceptViewController.swift
//  BlindCafe
//
//  Created by κΆνμ on 2021/11/29.
//

import UIKit

class ProfileAcceptViewController: BaseViewController {
    var id = 0

    @IBOutlet weak var acceptLabel1: UILabel!
    @IBOutlet weak var acceptLabel2: UILabel!
    
    @IBOutlet weak var partnerProfileImageView: UIImageView!
    @IBOutlet weak var partnerNickname: UILabel!
    @IBOutlet weak var partnerRegion: UILabel!
    
    @IBOutlet var partnerInterests: [UILabel]!
    
    @IBOutlet weak var partnerGenderLabel: UILabel!
    @IBOutlet weak var partnerAgeLabel: UILabel!
    
    
    @IBAction func rejectButton(_ sender: Any) {
        let vc = RejectReasonViewController()
        vc.partnerName = partnerNickname.text!
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func acceptButton(_ sender: Any) {
        showIndicator()
        let input = RequestMatchingInput()
        AcceptProfileDataManager().acceptProfile(input, id: UserDefaults.standard.integer(forKey: "MatchingId"), viewController: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNavigation()

        showIndicator()
        GetPartnerProfileDataManager().getPartnerProfile(id: UserDefaults.standard.integer(forKey: "MatchingId"), viewController: self)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(touchToViewPhoto))
        partnerProfileImageView.addGestureRecognizer(tapGesture)
        partnerProfileImageView.isUserInteractionEnabled = true
    }
    
    @objc func touchToViewPhoto() {
        let vc = PartnerProfileImageViewController()
        vc.modalPresentationStyle = .overCurrentContext
        vc.modalTransitionStyle = .crossDissolve
        vc.id = id
        present(vc, animated: false)
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
        titleLabel.text = "νλ‘ν μλ½νκΈ°"
        titleLabel.font = .SpoqaSans(.bold, size: 16)
        titleLabel.textColor = .white2
        titleLabel.textAlignment = .center
        titleview.addSubview(titleLabel)
        self.navigationItem.titleView = titleview
    }
    
    @objc func popToRoot() {
        navigationController?.popToRootViewController(animated: false)
    }

}

extension ProfileAcceptViewController {
    func getpartner(result: GetPartnerProfileResponse) {
        dismissIndicator()
        acceptLabel1.text = "72μκ°μ λνκ° μ’λ£λμμ΅λλ€.\nκ·Έ λμ \(result.nickname)λκ³Όμ λ§λ¨μ΄ μ¦κ±°μ°μ¨λμ?"
        acceptLabel2.text = "λ΄ νλ‘νμ λ©μ§κ² μ±μ°κ³  \(result.nickname)λμ νλ‘νμ λ°μλ³΄μΈμ!"
        
        if result.profileImage != nil {
            let url = URL(string: result.profileImage!)
            let data = try? Data(contentsOf: url!)
            partnerProfileImageView.image = UIImage(data: data!)
        }
        partnerNickname.text = result.nickname
        
        partnerRegion.text = result.region
        
        for i in 0...2 {
            partnerInterests[i].text = result.interests![i]
        }
        
        if result.gender == "F" {
            partnerGenderLabel.text = "μ¬μ"
        } else {
            partnerGenderLabel.text = "λ¨μ"
        }
        
        partnerAgeLabel.text = "\(result.age ?? 0)"
        
        id = result.userId!
    }
    
    func acceptProfile(result: AcceptProfileResponse) {
        dismissIndicator()
        if result.result == false {
            let vc = WaitProfileViewController()
            vc.partnerName = result.nickname
            navigationController?.pushViewController(vc, animated: true)
        } else {
            let vc = ProfileAcceptedViewController()
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}
