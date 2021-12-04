//
//  GetPartnerProfileDataManager.swift
//  BlindCafe
//
//  Created by 권하은 on 2021/11/29.
//

import Alamofire

class GetPartnerProfileDataManager {
    func getPartnerProfile(id: Int, viewController: ProfileAcceptViewController) {
        AF.request("\(Constant.BASE_URL)/api/matching/\(id)/partner", method: .get, headers: ["x-access-token": UserDefaults.standard.string(forKey: "UserJwt") ?? ""])
            .validate()
            .responseDecodable(of: GetPartnerProfileResponse.self) { response in
                switch response.result {
                case .success(let response):
                    viewController.getpartner(result: response)
                    print(response)
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
    }
}
