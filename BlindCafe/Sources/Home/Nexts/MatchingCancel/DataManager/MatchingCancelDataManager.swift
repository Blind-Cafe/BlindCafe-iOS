//
//  MatchingCancelDataManager.swift
//  BlindCafe
//
//  Created by 권하은 on 2021/11/26.
//

import Alamofire

class MatchingCancelDataManager {
    func matchingCancel(_ parameters: MatchingCancelInput, viewController: MatchingCancelViewController) {
        AF.request("\(Constant.BASE_URL)/api/matching/cancel", method: .post, parameters: parameters, encoder: JSONParameterEncoder.default, headers: Constant.HEADERS)
            .validate()
            .responseDecodable(of: MatchingCancelResponse.self) { response in
                switch response.result {
                case .success(let response):
                    print(response)
                case .failure(let error):
                    print(error.localizedDescription)
                }
                
                viewController.cancel()
            }
    }
}
