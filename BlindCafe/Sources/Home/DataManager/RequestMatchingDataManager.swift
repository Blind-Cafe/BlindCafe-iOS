//
//  RequestMatchingDataManager.swift
//  BlindCafe
//
//  Created by 권하은 on 2021/11/21.
//

import Alamofire

class RequestMatchingDataManager {
    func requestMatching(_ parameters: RequestMatchingInput, viewController: HomeViewController) {
        AF.request("\(Constant.BASE_URL)/api/matching", method: .post, parameters: parameters, encoder: JSONParameterEncoder.default, headers: ["x-access-token": UserDefaults.standard.string(forKey: "UserJwt") ?? ""])
            .validate()
            .responseDecodable(of: RequestMatchingResponse.self) { response in
                switch response.result {
                case .success(let response):
                    viewController.requestMatchingHome(result: response)
                    print(response)
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
    }
}
