//
//  LastViewController.swift
//  BlindCafe
//
//  Created by κΆνμ on 2021/12/01.
//

import UIKit

class LastViewController: UIViewController {

    @IBAction func leaveButton(_ sender: Any) {
        let controller = OnboardingViewController()
        let navController = UINavigationController(rootViewController: controller)
        navController.view.backgroundColor = .mainBlack
        navController.navigationBar.barTintColor = .mainBlack
        navController.modalPresentationStyle = .fullScreen
        navController.modalTransitionStyle = .crossDissolve
        present(navController, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

}
