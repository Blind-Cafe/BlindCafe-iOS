//
//  BaseTabBarController.swift
//  BlindCafe
//
//  Created by 권하은 on 2021/10/21.
//

import UIKit

class BaseTabBarController: UITabBarController, UITabBarControllerDelegate  {

    let homeViewController = HomeViewController()
    let homeTabBarItem = UITabBarItem(title: nil, image: UIImage(named: "homeitem"), tag: 0)

    let matchedViewController = MatchedViewController()
    let matchedTabBarItem = UITabBarItem(title: nil, image: UIImage(named: "matcheditem"), tag: 1)
    
    let mypageViewController = MyPageViewController()
    let mypageTabBarItem = UITabBarItem(title: nil, image: UIImage(named: "mypageitem"), tag: 2)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 15.0, *) {
            let appearance = UITabBarAppearance()
            appearance.configureWithDefaultBackground()
            appearance.backgroundColor = .black3
            tabBar.standardAppearance = appearance
            tabBar.scrollEdgeAppearance = tabBar.standardAppearance
        }
        
        tabBar.isTranslucent = false
        tabBar.barTintColor = .black3
        view.backgroundColor = .mainBlack
        
        let homeNavController = UINavigationController(rootViewController: homeViewController)
        let matchedNavController = UINavigationController(rootViewController: matchedViewController)
        let mypageNavController = UINavigationController(rootViewController: mypageViewController)
        
        homeNavController.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        homeNavController.navigationController?.navigationBar.shadowImage = UIImage()
        homeNavController.navigationController?.navigationBar.layoutIfNeeded()
        
        matchedNavController.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        matchedNavController.navigationController?.navigationBar.shadowImage = UIImage()
        matchedNavController.navigationController?.navigationBar.layoutIfNeeded()
        
        mypageNavController.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        mypageNavController.navigationController?.navigationBar.shadowImage = UIImage()
        mypageNavController.navigationController?.navigationBar.layoutIfNeeded()
        
        homeNavController.tabBarItem = homeTabBarItem
        homeNavController.tabBarItem.selectedImage = UIImage(named: "homeitemselected")
        matchedNavController.tabBarItem = matchedTabBarItem
        matchedNavController.tabBarItem.selectedImage = UIImage(named: "matcheditemselected")
        mypageNavController.tabBarItem = mypageTabBarItem
        mypageNavController.tabBarItem.selectedImage = UIImage(named: "mypageitemselected")
        
        
        self.viewControllers = [homeNavController, matchedNavController, mypageNavController]
        
        self.delegate = self
    }
    

}
