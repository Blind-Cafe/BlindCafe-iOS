//
//  PutProfileDataManager.swift
//  BlindCafe
//
//  Created by 권하은 on 2021/11/27.
//

import Alamofire

class PutProfileDataManager {
    func putProfile(_ parameters: PutProfileInput, viewController: ProfileViewController) {
        AF.request("\(Constant.BASE_URL)/api/user", method: .put, parameters: parameters, encoder: JSONParameterEncoder.default, headers: ["x-access-token": UserDefaults.standard.string(forKey: "UserJwt") ?? ""])
            .validate()
            .responseDecodable(of: PutProfileResponse.self) { response in
                switch response.result {
                case .success(let response):
                    viewController.putprofile(result: response)
                    print(response)
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
    }
}
