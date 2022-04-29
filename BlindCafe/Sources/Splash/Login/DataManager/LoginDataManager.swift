//
//  LoginDataManager.swift
//  BlindCafe
//
//  Created by 권하은 on 2022/04/27.
//

import Foundation
import Alamofire

class LoginDataManager {
    func login(_ parameters: LoginInput, viewController: LoginViewController) {
        AF.request("\(Constant.BASE_URL)/api/auth/login", method: .post, parameters: parameters, encoder: JSONParameterEncoder.default )
            .validate()
            .responseDecodable(of: LoginResponse.self) { response in
                switch response.result {
                case .success(let response1):
                    viewController.didLogin(result: response1, code: response.response!.statusCode)
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
    }
}
