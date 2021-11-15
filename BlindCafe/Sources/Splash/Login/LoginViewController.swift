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

class LoginViewController: BaseOnboardingViewController {
    
    @IBOutlet weak var appleLoginView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
        addButton()
    }
    
    func addButton() {
        let button = ASAuthorizationAppleIDButton(authorizationButtonType: .signIn, authorizationButtonStyle: .black)
        button.addTarget(self, action: #selector(appleLoginHandler), for: .touchUpInside)
        
        appleLoginView.addSubview(button)
        button.frame = CGRect(x: 0, y: 0, width: appleLoginView.frame.width, height: appleLoginView.frame.height)
    }
    
    @objc func appleLoginHandler() {
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
                let input = LoginInput(token: oauthToken!.accessToken, deviceId: UserDefaults.standard.string(forKey: "FCMToken") ?? "")
                KakaoLoginDataManager().kakaoLogin(input, viewController: self)
                
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
                let input = LoginInput(token: tokenString, deviceId: UserDefaults.standard.string(forKey: "FCMToken") ?? "")
                AppleLoginDataManager().appleLogin(input, viewController: self)
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
    func didLogin(result: LoginResponse){
        self.dismissIndicator()
        Token.jwtToken = result.jwt!
        UserDefaults.standard.set(result.jwt, forKey: "UserJwt")
        UserDefaults.standard.set(result.id, forKey: "UserID")
        let vc = AgreementViewController()
        let navController = UINavigationController(rootViewController: vc)
        //navController.modalPresentationStyle = .fullScreen
        //navController.modalTransitionStyle = .crossDissolve
        navController.view.backgroundColor = .mainBlack
        navController.navigationBar.isTranslucent = false
        //self.present(navController, animated: true)
        changeRootViewController(navController)
    }
    
    func failedToRequest(message: String) {
        dismissIndicator()
        presentAlert(message: message)
    }
}
