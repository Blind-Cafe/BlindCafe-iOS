//
//  IndicatorView.swift
//  BlindCafe
//
//  Created by 권하은 on 2021/10/27.
//

import UIKit
import Lottie

open class IndicatorView {
    static let shared = IndicatorView()
        
    let animationView = UIView()
    let activityIndicator = AnimationView()
    
    open func show() {
        let window = UIWindow(frame: UIScreen.main.bounds)
        
        self.animationView.frame = window.frame
        self.animationView.center = window.center
        self.animationView.backgroundColor = .clear
        
        self.animationView.addSubview(self.activityIndicator)
        UIApplication.shared.windows.first?.addSubview(animationView)
    }
    
    open func showIndicator() {
        activityIndicator.backgroundColor = UIColor(hex: 0x000000, alpha: 0.4)
        
        activityIndicator.frame =  CGRect(x: 0, y: 0, width: 60, height: 60)
        activityIndicator.center = self.animationView.center
        
        activityIndicator.animation = Animation.named("data")
        activityIndicator.contentMode = .scaleAspectFit
        activityIndicator.loopMode = .loop
        activityIndicator.play()
    }
    
    open func dismiss() {
        self.activityIndicator.stop()
        self.animationView.removeFromSuperview()
    }
}
