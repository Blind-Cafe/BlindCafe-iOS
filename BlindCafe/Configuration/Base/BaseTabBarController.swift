//
//  BaseTabBarController.swift
//  BlindCafe
//
//  Created by 권하은 on 2021/10/21.
//

import UIKit

class BaseTabBarController: UITabBarController, UITabBarControllerDelegate  {

    let homeViewController = HomeViewController()

    let matchedViewController = MatchedViewController()
    
    let mypageViewController = MyPageViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tabBar.isTranslucent = false
        tabBar.barTintColor = .mainGreen
        UITabBar.appearance().backgroundColor = .black2
        
        let homeNavController = UINavigationController(rootViewController: homeViewController)
        let matchedNavController = UINavigationController(rootViewController: matchedViewController)
        let mypageNavController = UINavigationController(rootViewController: mypageViewController)
        
        homeNavController.tabBarItem.image = UIImage(named: "homeitem")
        homeNavController.tabBarItem.selectedImage = UIImage(named: "homeitemselected")
        matchedNavController.tabBarItem.image = UIImage(named: "matcheditem")
        matchedNavController.tabBarItem.selectedImage = UIImage(named: "matcheditemselected")
        mypageNavController.tabBarItem.image = UIImage(named: "mypageitem")
        mypageNavController.tabBarItem.selectedImage = UIImage(named: "mypageitemselected")
        
        
        self.viewControllers = [homeNavController, matchedNavController, mypageNavController]
        
        self.delegate = self
    }

}
