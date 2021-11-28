//
//  ProfileOpenDataManager.swift
//  BlindCafe
//
//  Created by 권하은 on 2021/11/29.
//

import Alamofire

class ProfileOpenDataManager {
    func getProfile(id: Int, viewController: ProfileOpenViewController) {
        AF.request("\(Constant.BASE_URL)/api/matching/\(id)/profile", method: .get, headers: Constant.HEADERS)
            .validate()
            .responseDecodable(of: ProfileOpenResponse.self) { response in
                switch response.result {
                case .success(let response):
                    viewController.getprofile(result: response)
                    print(response)
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
    }
}

