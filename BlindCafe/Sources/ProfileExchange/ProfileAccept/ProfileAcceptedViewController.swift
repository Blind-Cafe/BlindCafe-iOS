//
//  ProfileAcceptedViewController.swift
//  BlindCafe
//
//  Created by 권하은 on 2021/11/29.
//

import UIKit

class ProfileAcceptedViewController: BaseViewController {

    @IBAction func toMyTableButton(_ sender: Any) {
        let vc = BaseTabBarController()
        vc.selectedIndex = 1
        
        changeRootViewController(vc)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isHidden = true
        // Do any additional setup after loading the view.
    }



}
