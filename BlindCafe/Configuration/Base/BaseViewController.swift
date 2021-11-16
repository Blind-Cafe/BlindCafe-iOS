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
        
        view.backgroundColor = .mainBlack
        navigationController?.navigationBar.isHidden = false
        navigationController?.navigationBar.isTranslucent = false
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
