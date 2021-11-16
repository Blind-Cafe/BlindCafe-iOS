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
        
        view.backgroundColor = .mainBlack
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.barTintColor = .mainBlack
    }
    
    func setBackButton() {
        let backButton: UIButton = UIButton()
        backButton.setImage(UIImage(named: "backbutton"), for: .normal)
        backButton.addTarget(self, action: #selector(popToVC), for: .touchUpInside)
        backButton.frame = CGRect(x: 18, y: 0, width: 44, height: 44)
        let addBackButton = UIBarButtonItem(customView: backButton)
        
        self.navigationItem.setLeftBarButton(addBackButton, animated: false)
        
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont.SpoqaSans(.bold, size: 16), NSAttributedString.Key.foregroundColor: UIColor.veryLightPink]
        self.title = "프로필 설정"
    }
    
    @objc func popToVC() {
        navigationController?.popViewController(animated: true)
    }
    
    func showIndicator() {
        animationView = Lottie.AnimationView.init(name: "data")
        animationView.backgroundColor = UIColor(hex: 0x000000, alpha: 0.3)
        animationView.frame = UIScreen.main.bounds
        animationView.center = CGPoint(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.height / 2)
        
        animationView.contentMode = .scaleAspectFit
        animationView.loopMode = .loop
        
        animationView.play()
        view.addSubview(animationView)
    }
    
    func dismissIndicator() {
        animationView.stop()
        animationView.removeFromSuperview()
    }
}
