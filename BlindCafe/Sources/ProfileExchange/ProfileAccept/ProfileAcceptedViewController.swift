//
//  ProfileAcceptedViewController.swift
//  BlindCafe
//
//  Created by κΆνμ on 2021/11/29.
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
    }



}
