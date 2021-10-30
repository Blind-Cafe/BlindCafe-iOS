//
//  KakaoLoginDataManager.swift
//  BlindCafe
//
//  Created by 권하은 on 2021/10/27.
//

import Alamofire

class KakaoLoginDataManager {
    func kakaoLogin(_ parameters: KakaoLoginInput, viewController: LoginViewController) {
        AF.request("\(Constant.BASE_URL)/api/kakao", method: .post, parameters: parameters, encoder: JSONParameterEncoder.default)
            .validate()
            .responseDecodable(of: KakaoLoginResponse.self) { response in
                switch response.result {
                case .success(let response):
                    if response.code == "1000" || response.code == "1001" {
                        viewController.didLogin(code: response.code, jwt: response.jwt!)
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
