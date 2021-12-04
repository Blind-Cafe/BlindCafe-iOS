//
//  AcceptProfileDataManager.swift
//  BlindCafe
//
//  Created by 권하은 on 2021/11/29.
//

import Alamofire

class AcceptProfileDataManager {
    func acceptProfile(_ parameters: RequestMatchingInput, id: Int, viewController: ProfileAcceptViewController) {
        AF.request("\(Constant.BASE_URL)/api/matching/\(id)/partner", method: .post, parameters: parameters, encoder: JSONParameterEncoder.default, headers: ["x-access-token": UserDefaults.standard.string(forKey: "UserJwt") ?? ""])
            .validate()
            .responseDecodable(of: AcceptProfileResponse.self) { response in
                switch response.result {
                case .success(let response):
                    viewController.acceptProfile(result: response)
                    print(response)
                case .failure(let error):
                    viewController.changeRootViewController(BaseTabBarController())
                    print(error.localizedDescription)
                }
            }
    }
}
