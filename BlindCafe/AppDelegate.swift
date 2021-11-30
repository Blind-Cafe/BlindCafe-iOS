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
import UserNotifications
import FirebaseMessaging
import Photos

var allPhotos : PHFetchResult<PHAsset>? = nil
var photocount = Int()

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    let gcmMessageIDKey = "path"
    
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
        
        PHPhotoLibrary.requestAuthorization { (status) in
            switch status {
            case .authorized:
                let fetchOptions = PHFetchOptions()
                fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
                fetchOptions.predicate = NSPredicate(format: "mediaType = %d", PHAssetMediaType.image.rawValue)
                allPhotos = PHAsset.fetchAssets(with: .image, options: fetchOptions)
                photocount = allPhotos?.count ?? 0
            case .denied, .restricted:
                print("Not allowed")
            case .notDetermined:
                print("not determined yet")
            @unknown default:
                print("error")
            }
        }
        
        let audioSession = AVAudioSession.sharedInstance()
        do {
            // 오디오 세션 카테고리, 모드, 옵션 설정
            try audioSession.setCategory(.playback, mode: .moviePlayback, options: [])
        } catch {
            print("Failed to set audio session category.")
        }
        
        KakaoSDKCommon.initSDK(appKey: KakaoKey.KAKAO_NATIVE_KEY)
        FirebaseApp.configure()
        
        Messaging.messaging().delegate = self
        
        UNUserNotificationCenter.current().delegate = self
        
        
        let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
        UNUserNotificationCenter.current().requestAuthorization(options: authOptions) { granted, error in
            if granted {
                print("알림 등록이 완료되었습니다.")
            }
        }
        
        application.registerForRemoteNotifications()
        if UserDefaults.standard.bool(forKey: "Setting1") == true {
            application.unregisterForRemoteNotifications()
        }
        
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

extension AppDelegate: UNUserNotificationCenterDelegate {
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        Messaging.messaging().apnsToken = deviceToken
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.body
        print(userInfo)
    }
}

extension AppDelegate: MessagingDelegate {
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        //이 값을 서버로
        print("FCM Token: \(fcmToken ?? "")")
        UserDefaults.standard.setValue(fcmToken, forKey: "FCMToken")
    }
}
