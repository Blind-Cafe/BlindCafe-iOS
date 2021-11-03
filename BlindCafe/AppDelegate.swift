//
//  AppDelegate.swift
//  BlindCafe
//
//  Created by 권하은 on 2021/10/19.
//

import UIKit
import AuthenticationServices
import KakaoSDKCommon
import Firebase

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let appleIDProvider = ASAuthorizationAppleIDProvider()

        /*appleIDProvider.getCredentialState(forUserID: "haeunk1029@naver.com") { (credentialState, error) in
            switch credentialState {
            case .authorized:
                print("authorized")
            case .revoked:
                print("revoked")
            case .notFound:
                // The Apple ID credential is either revoked or was not found, so show the sign-in UI.
                print("notFound")
                DispatchQueue.main.async {
                    //self.window?.rootViewController?.LoginViewController()
                }
            default:
                break
            }
        }*/
        
        KakaoSDKCommon.initSDK(appKey: KakaoKey.KAKAO_NATIVE_KEY)
        FirebaseApp.configure()
        
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

