//
//  PostUserInfoDataManager.swift
//  BlindCafe
//
//  Created by 권하은 on 2021/11/16.
//

import Alamofire

class PostUserInfoDataManager {
    func postUserInfo(_ parameters: PostUserInfoInput, viewController: InitDetailInterestViewController) {
        AF.request("\(Constant.BASE_URL)/api/user", method: .post, parameters: parameters, encoder: JSONParameterEncoder.default, headers: Constant.HEADERS)
            .validate()
            .responseDecodable(of: PostUserInfoResponse.self) { response in
                switch response.result {
                case .success(let response):
                    if response.code != "1000" {
                        viewController.failedToRequest(message: response.message)
                    }
                    else {
                        viewController.requested()
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
    }
}
