//
//  DoneSignUpViewController.swift
//  BlindCafe
//
//  Created by 권하은 on 2021/11/16.
//

import UIKit

class DoneSignUpViewController: BaseOnboardingViewController {

    @IBAction func toHomeButton(_ sender: Any) {
        changeRootViewController(BaseTabBarController())
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setBackButton()
        self.title = "회원가입 완료"
        // Do any additional setup after loading the view.
    }

}
