//
//  FCMDataManager.swift
//  BlindCafe
//
//  Created by 권하은 on 2021/11/22.
//

import Alamofire

class FCMDataManager {
    func requestFCM(_ parameters: FCMInput, viewController: ChattingViewController) {
        AF.request("\(Constant.BASE_URL)/fcm", method: .post, parameters: parameters, encoder: JSONParameterEncoder.default, headers: Constant.HEADERS)
            .validate()
            .responseDecodable(of: FCMResponse.self) { response in
                switch response.result {
                case .success(let response):
                    //viewController.requestMatchingHome(result: response)
                    print(response)
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
    }
}
