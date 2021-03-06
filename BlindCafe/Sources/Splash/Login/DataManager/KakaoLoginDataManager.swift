//
//  KakaoLoginDataManager.swift
//  BlindCafe
//
//  Created by κΆνμ on 2021/10/27.
//

import Alamofire

class KakaoLoginDataManager {
    func kakaoLogin(_ parameters: LoginInput, viewController: LoginViewController) {
        AF.request("\(Constant.BASE_URL)/api/kakao", method: .post, parameters: parameters, encoder: JSONParameterEncoder.default)
            .validate()
            .responseDecodable(of: LoginResponse.self) { response in
                switch response.result {
                case .success(let response):
                    if response.code == "990" || response.code == "991" || response.code == "992"{
                        viewController.didLogin(result: response)
                        UserDefaults.standard.set(response.code, forKey: "Status")
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
