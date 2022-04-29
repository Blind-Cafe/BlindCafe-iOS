//
//  LoginViewController.swift
//  BlindCafe
//
//  Created by 권하은 on 2021/10/20.
//

import UIKit
import AuthenticationServices
import KakaoSDKAuth
import KakaoSDKUser
import Lottie

class LoginViewController: BaseOnboardingViewController {
    
    @IBAction func policy1Button(_ sender: Any) {
        let vc = Policy1ViewController()
        vc.modalPresentationStyle = .fullScreen
        vc.modalTransitionStyle = .crossDissolve
        present(vc, animated: true, completion: nil)
    }
    
    @IBAction func policy2Button(_ sender: Any) {
        let vc = Policy2ViewController()
        vc.modalPresentationStyle = .fullScreen
        vc.modalTransitionStyle = .crossDissolve
        present(vc, animated: true, completion: nil)
    }
    
    @IBOutlet weak var appleLoginButton: ASAuthorizationAppleIDButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
    }
    
    @IBAction func appleLoginHandler(_ sender: Any) {
        let request = ASAuthorizationAppleIDProvider().createRequest()
        request.requestedScopes = [.fullName, .email]
        let controller = ASAuthorizationController(authorizationRequests: [request])
        controller.delegate = self
        controller.presentationContextProvider = self
        controller.performRequests()
    }
    
    @IBAction func kakaoLoginButton(_ sender: Any) {
        UserApi.shared.loginWithKakaoAccount {(oauthToken, error) in
            if let error = error {
                print(error)
            }
            else {
                print("loginWithKakaoAccount() success.")
                
                self.showIndicator()
                let input = LoginInput(platform: "IOS", social: "KAKAO", accessToken: oauthToken!.accessToken, deviceToken: UserDefaults.standard.string(forKey: "FCMToken") ?? "")
                LoginDataManager().login(input, viewController: self)
                
                print(input)
                print(oauthToken!.accessToken, "액세스 토큰")
                
                _ = oauthToken
            }
        }
    }
}

extension LoginViewController: ASAuthorizationControllerDelegate {
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        
        switch authorization.credential { case let appleIDCredential as ASAuthorizationAppleIDCredential:
            // Create an account in your system.
            let userIdentifier = appleIDCredential.user
            let fullName = appleIDCredential.fullName
            let email = appleIDCredential.email
            if let authorizationCode = appleIDCredential.authorizationCode,
               let identityToken = appleIDCredential.identityToken,
               let authString = String(data: authorizationCode, encoding: .utf8),
               let tokenString = String(data: identityToken, encoding: .utf8) {
                print("authorizationCode: \(authorizationCode)")
                print("identityToken: \(identityToken)")
                print("authString: \(authString)")
                print("tokenString: \(tokenString)")
                self.showIndicator()
                let input = LoginInput(platform: "IOS", social: "APPLE", accessToken: tokenString, deviceToken: UserDefaults.standard.string(forKey: "FCMToken") ?? "")
                LoginDataManager().login(input, viewController: self)
                print(input)
            }
            
            print("useridentifier: \(userIdentifier)")
            print("fullName: \(String(describing: fullName))")
            print("email: \(String(describing: email))")
            
        case let passwordCredential as ASPasswordCredential:
            // Sign in using an existing iCloud Keychain credential.
            let username = passwordCredential.user
            let password = passwordCredential.password
            print("username: \(username)")
            print("password: \(password)")
        default:
            break
        }
        
        
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        print("error \(error)")
    }
}

extension LoginViewController: ASAuthorizationControllerPresentationContextProviding {
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.view.window!
    }
}

extension LoginViewController {
    func didLogin(result: LoginResponse, code: Int){
        self.dismissIndicator()
        Token.jwtToken = result.accessToken!
        UserDefaults.standard.setValue(result.accessToken, forKey: "UserJwt")
        UserDefaults.standard.setValue(result.refreshToken, forKey: "UserRefresh")
        UserDefaults.standard.setValue(result.uid, forKey: "UserID")
        UserDefaults.standard.set(result.nickname, forKey: "UserNickname")
        if code == 200 {
            UserDefaults.standard.setValue(1, forKey: "Status")
            changeRootViewController(BaseTabBarController())
        }
        else {
            UserDefaults.standard.setValue(0, forKey: "Status")
            let vc = InitNicknameViewController()
            let navController = UINavigationController(rootViewController: vc)
            navController.view.backgroundColor = .mainBlack
            navController.navigationBar.isTranslucent = false
            changeRootViewController(navController)
        }
    }
    
    func failedToRequest(message: String) {
        dismissIndicator()
        presentAlert(message: message)
    }
}
