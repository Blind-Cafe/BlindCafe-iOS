//
//  ProfileAcceptViewController.swift
//  BlindCafe
//
//  Created by 권하은 on 2021/11/29.
//

import UIKit

class ProfileAcceptViewController: BaseViewController {

    @IBOutlet weak var acceptLabel1: UILabel!
    @IBOutlet weak var acceptLabel2: UILabel!
    
    @IBOutlet weak var partnerProfileImageView: UIImageView!
    @IBOutlet weak var partnerNickname: UILabel!
    @IBOutlet weak var partnerRegion: UILabel!
    
    @IBOutlet var partnerInterests: [UILabel]!
    
    @IBOutlet weak var partnerGenderLabel: UILabel!
    @IBOutlet weak var partnerAgeLabel: UILabel!
    
    
    @IBAction func acceptButton(_ sender: Any) {
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        showIndicator()
        GetPartnerProfileDataManager().getPartnerProfile(id: UserDefaults.standard.integer(forKey: "MatchingId"), viewController: self)
    }

}

extension ProfileAcceptViewController {
    func getpartner(result: GetPartnerProfileResponse) {
        dismissIndicator()
        acceptLabel1.text = "72시간의 대화가 종료되었습니다.\n그 동안 \(result.nickname)님과의 만남이 즐거우셨나요?"
        acceptLabel2.text = "내 프로필을 멋지게 채우고 \(result.nickname)님의 프로필을 받아보세요!"
        
        if result.profileImage != nil {
            let url = URL(string: result.profileImage!)
            let data = try? Data(contentsOf: url!)
            partnerProfileImageView.image = UIImage(data: data!)
        }
        
        partnerRegion.text = result.region
        
        for i in 0...2 {
            partnerInterests[i].text = result.interests![0]
        }
        
        if result.gender == "F" {
            partnerGenderLabel.text = "여자"
        } else {
            partnerGenderLabel.text = "남자"
        }
        
        partnerAgeLabel.text = "\(String(describing: result.age))"
        
    }
}
