//
//  HomeViewController.swift
//  BlindCafe
//
//  Created by 권하은 on 2021/10/21.
//

import UIKit

class HomeViewController: BaseViewController {

    @IBAction func toChatting(_ sender: Any) {
        let vc = ChattingViewController()
        vc.modalPresentationStyle = .fullScreen
        vc.modalTransitionStyle = .crossDissolve
        
        self.present(vc, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }



}
