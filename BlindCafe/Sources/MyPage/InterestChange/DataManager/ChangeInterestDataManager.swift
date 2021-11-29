//
//  ChangeInterestDataManager.swift
//  BlindCafe
//
//  Created by 권하은 on 2021/11/29.
//

import Alamofire

class ChangeInterestDataManager {
    func getInterest(id1: String, id2: String, id3: String, viewController: InterestDetailChangeViewController) {
        AF.request("\(Constant.BASE_URL)/api/interest?id=\(id1)&id=\(id2)&id=\(id3)", method: .get, parameters: nil, headers: Constant.HEADERS)
            .validate()
            .responseDecodable(of: InterestResponse.self) { response in
                switch response.result {
                case .success(let response):
                    viewController.getInterest(result: response)
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
    }
}