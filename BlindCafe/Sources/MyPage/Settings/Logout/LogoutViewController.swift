//
//  LogoutViewController.swift
//  BlindCafe
//
//  Created by 권하은 on 2021/11/30.
//

import UIKit

class LogoutViewController: BaseViewController {

    @IBAction func dismissButton(_ sender: Any) {
        dismiss(animated: false, completion: nil)
    }
    
    @IBAction func logoutButton(_ sender: Any) {
        UserDefaults.standard.set("", forKey: "UserJwt")
        changeRootViewController(OnboardingViewController())
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }


}
