//
//  WaitProfileViewController.swift
//  BlindCafe
//
//  Created by 권하은 on 2021/11/29.
//

import UIKit

class WaitProfileViewController: BaseViewController {
    var partnerName = ""
    
    @IBOutlet weak var waitLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigation()
        
        waitLabel.text = "\(partnerName)님의 답변을 기다리고 있습니다.\n잠시만 기다려주세요"
    }
    
    func setNavigation() {
        let backButton: UIButton = UIButton()
        backButton.setImage(UIImage(named: "backbutton"), for: .normal)
        backButton.addTarget(self, action: #selector(popToRoot), for: .touchUpInside)
        backButton.frame = CGRect(x: 18, y: 0, width: 44, height: 44)
        let addBackButton = UIBarButtonItem(customView: backButton)
        
        self.navigationItem.setLeftBarButton(addBackButton, animated: false)
    }
    
    @objc func popToRoot() {
        navigationController?.popToRootViewController(animated: false)
    }

}
