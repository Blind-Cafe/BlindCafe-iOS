//
//  AppleLoginDataManager.swift
//  BlindCafe
//
//  Created by 권하은 on 2021/10/29.
//

import Alamofire

class AppleLoginDataManager {
    func appleLogin(_ parameters: LoginInput, viewController: LoginViewController) {
        AF.request("\(Constant.BASE_URL)/api/apple", method: .post, parameters: parameters, encoder: JSONParameterEncoder.default)
            .validate()
            .responseDecodable(of: LoginResponse.self) { response in
                switch response.result {
                case .success(let response):
                    if response.code == "990" || response.code == "991" || response.code == "992" {
                        viewController.didLogin(result: response)
                    }
                    else {
                        viewController.failedToRequest(message: response.message)
                    }
                    print(response)
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
    }
}
