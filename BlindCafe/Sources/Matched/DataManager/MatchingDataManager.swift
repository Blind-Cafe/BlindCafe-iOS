//
//  MatchingDataManager.swift
//  BlindCafe
//
//  Created by 권하은 on 2021/11/17.
//

import Alamofire

class MatchingDataManager {
    func getMatchings(viewController: MatchedViewController) {
        AF.request("\(Constant.BASE_URL)/api/matching", method: .get, parameters: nil, headers: Constant.HEADERS)
            .validate()
            .responseDecodable(of: MatchingResponse.self) { response in
                switch response.result {
                case .success(let response):
                    viewController.getMatching(result: response)
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
    }
}
