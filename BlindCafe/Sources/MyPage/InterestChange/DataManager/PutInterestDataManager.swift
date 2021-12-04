//
//  PutInterestDataManager.swift
//  BlindCafe
//
//  Created by 권하은 on 2021/11/29.
//

import Alamofire

class PutInterestDataManager {
    func putInterest(_ parameters: PutInterestInput, viewController: InterestDetailChangeViewController) {
        AF.request("\(Constant.BASE_URL)/api/user/interest", method: .put, parameters: parameters, encoder: JSONParameterEncoder.default, headers: ["x-access-token": UserDefaults.standard.string(forKey: "UserJwt") ?? ""])
            .validate()
            .responseDecodable(of: PutInterestResponse.self) { response in
                switch response.result {
                case .success(let response):
                    if response.code == "1000" {
                        viewController.requested()
                    }
                    print(response)
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
    }
}
