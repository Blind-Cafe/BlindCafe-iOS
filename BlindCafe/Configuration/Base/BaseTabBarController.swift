//
//  BaseTabBarController.swift
//  BlindCafe
//
//  Created by 권하은 on 2021/10/21.
//

import UIKit

class BaseTabBarController: UITabBarController, UITabBarControllerDelegate  {

    let homeViewController = HomeViewController()
    let homeTabBarItem = UITabBarItem(title: "Home", image: nil, tag: 0)

    let matchedViewController = MatchedViewController()
    let matchedTabBarItem = UITabBarItem(title: "매칭완료", image: nil, tag: 1)
    
    let mypageViewController = MyPageViewController()
    let mypageTabBarItem = UITabBarItem(title: "마이페이지", image: nil, tag: 2)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let homeNavController = UINavigationController(rootViewController: homeViewController)
        let matchedNavController = UINavigationController(rootViewController: matchedViewController)
        let mypageNavController = UINavigationController(rootViewController: mypageViewController)
        
        homeNavController.tabBarItem = homeTabBarItem
        matchedNavController.tabBarItem = matchedTabBarItem
        mypageNavController.tabBarItem = mypageTabBarItem
        
        
        self.viewControllers = [homeNavController, matchedNavController, mypageNavController]
        
        self.delegate = self
    }

}
