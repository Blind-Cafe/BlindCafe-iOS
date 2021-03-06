//
//  ProfileAcceptDataManager.swift
//  BlindCafe
//
//  Created by κΆνμ on 2021/11/29.
//

import Alamofire

class ProfileAcceptDataManager {
    func profileAccept(id: Int, viewController: HomeViewController) {
        AF.request("\(Constant.BASE_URL)/api/matching/\(id)", method: .get, headers: ["x-access-token": UserDefaults.standard.string(forKey: "UserJwt") ?? ""])
            .validate()
            .responseDecodable(of: GetMatchingResponse.self) { response in
                switch response.result {
                case .success(let response):
                    viewController.profileAccepted(result: response)
                    print(response)
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
    }
}
