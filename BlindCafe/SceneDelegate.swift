//
//  SceneDelegate.swift
//  BlindCafe
//
//  Created by 권하은 on 2021/10/19.
//

import UIKit
import KakaoSDKAuth

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        let win = UIWindow(windowScene: windowScene)
        
        var controller: UIViewController
        
        if Token.jwtToken == "" {
            controller = OnboardingViewController()
            let navController = UINavigationController(rootViewController: controller)
            navController.view.backgroundColor = .mainBlack
            win.rootViewController = navController
            win.makeKeyAndVisible()
            window = win
        }
        else {
            if  UserDefaults.standard.string(forKey: "Status") == "990" {
                controller = BaseTabBarController()
                win.rootViewController = controller
                win.makeKeyAndVisible()
                window = win
            } else {
                controller = AgreementViewController()
                let navController = UINavigationController(rootViewController: controller)
                navController.view.backgroundColor = .mainBlack
                navController.navigationBar.isTranslucent = false
                win.rootViewController = navController
                win.makeKeyAndVisible()
                window = win
            }
        }
        
    }

    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        if let url = URLContexts.first?.url {
            if (AuthApi.isKakaoTalkLoginUrl(url)){
                _ = AuthController.handleOpenUrl(url: url)
            }
        }
    }
    
    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
        self.window?.viewWithTag(1234)?.removeFromSuperview()
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
        /*let blurEffect = UIBlurEffect(style:.light)
        let visualEffectView = UIVisualEffectView(effect: blurEffect)
        visualEffectView.frame = window!.frame
        visualEffectView.tag = 1234
        self.window?.addSubview(visualEffectView)*/
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        guard let start = UserDefaults.standard.object(forKey: "sceneDidEnterBackground") as? Date else { return }
        let interval = Int(Date().timeIntervalSince(start))
        NotificationCenter.default.post(name: NSNotification.Name("sceneWillEnterForeground"), object: nil, userInfo: ["time" : interval])
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        NotificationCenter.default.post(name: NSNotification.Name("sceneDidEnterBackground"), object: nil)
        UserDefaults.standard.setValue(Date(), forKey: "sceneDidEnterBackground")
    }


}

