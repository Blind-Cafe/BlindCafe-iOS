//
//  BaseViewController.swift
//  BlindCafe
//
//  Created by 권하은 on 2021/10/21.
//

import UIKit
import Lottie

class BaseViewController: UIViewController {

    var animationView: AnimationView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 15, *) {
            let appearance = UINavigationBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = .clear
            UINavigationBar.appearance().standardAppearance = appearance
            UINavigationBar.appearance().scrollEdgeAppearance = appearance
        }
        
        view.backgroundColor = .mainBlack
        navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont.SpoqaSans(.bold, size: 16), NSAttributedString.Key.foregroundColor: UIColor.veryLightPink]
        
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.layoutIfNeeded()
    }
    
    @objc func popToVC() {
        navigationController?.popViewController(animated: true)
    }
    
    func showHomeIndicator() {
        animationView = Lottie.AnimationView.init(name: "data")
        animationView.backgroundColor = UIColor(hex: 0x000000, alpha: 0.3)
        animationView.frame = UIScreen.main.bounds
        animationView.center = CGPoint(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.height / 2)
        
        animationView.contentMode = .scaleAspectFit
        animationView.loopMode = .loop
        
        animationView.play()
        view.addSubview(animationView)
    }
    
    func dismissHomeIndicator() {
        animationView.stop()
        animationView.removeFromSuperview()
    }
}
