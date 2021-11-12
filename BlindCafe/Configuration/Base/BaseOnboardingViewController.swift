//
//  BaseOnboardingViewController.swift
//  BlindCafe
//
//  Created by 권하은 on 2021/11/12.
//

import UIKit

class BaseOnboardingViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .mainBlack
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.barTintColor = .mainBlack
    }
}
