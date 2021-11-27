//
//  GetProfileDataManager.swift
//  BlindCafe
//
//  Created by 권하은 on 2021/11/27.
//

import Alamofire

class GetProfileDataManager {
    func getProfile(viewController: ProfileViewController) {
        AF.request("\(Constant.BASE_URL)/api/user/profile", method: .get, headers: Constant.HEADERS)
            .validate()
            .responseDecodable(of: GetProfileResponse.self) { response in
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
