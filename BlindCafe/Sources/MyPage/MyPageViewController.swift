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

        showIndicator()
        MyPageDataManager().requestMyPage(viewController: self)
    }
    
}

extension MyPageViewController {
    func request(result: MyPageResponse) {
        dismissIndicator()
        nameLabel.text = result.nickname
        
    }
    
    func failedToRequest(message: String) {
        dismissIndicator()
        presentAlert(message: message)
    }
}
