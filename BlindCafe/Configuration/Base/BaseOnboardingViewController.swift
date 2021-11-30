//
//  BaseOnboardingViewController.swift
//  BlindCafe
//
//  Created by 권하은 on 2021/11/12.
//

import UIKit
import Lottie

class BaseOnboardingViewController: UIViewController {

    var animationView: AnimationView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 15, *) {
            let appearance = UINavigationBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = .clear
            appearance.shadowColor = .mainBlack
            UINavigationBar.appearance().standardAppearance = appearance
            UINavigationBar.appearance().scrollEdgeAppearance = appearance
            
        }
        
        view.backgroundColor = .mainBlack
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.barTintColor = .mainBlack
        
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.layoutIfNeeded()
    }
    
    func setBackButton() {
        let backButton: UIButton = UIButton()
        backButton.setImage(UIImage(named: "backbutton"), for: .normal)
        backButton.addTarget(self, action: #selector(popToVC), for: .touchUpInside)
        backButton.frame = CGRect(x: 18, y: 0, width: 44, height: 44)
        let addBackButton = UIBarButtonItem(customView: backButton)
        
        self.navigationItem.setLeftBarButton(addBackButton, animated: false)
        
        let titleview = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 44))
        let titleLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 100, height: 44))
        titleLabel.text = "프로필 설정"
        titleLabel.font = .SpoqaSans(.bold, size: 16)
        titleLabel.textColor = .white2
        titleLabel.textAlignment = .center
        titleview.addSubview(titleLabel)
        self.navigationItem.titleView = titleview
    }
    
    @objc func popToVC() {
        navigationController?.popViewController(animated: true)
    }
}
