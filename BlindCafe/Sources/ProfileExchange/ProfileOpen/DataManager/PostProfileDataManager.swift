//
//  PostProfileDataManager.swift
//  BlindCafe
//
//  Created by κΆνμ on 2021/11/29.
//

import Alamofire

class PostProfileDataManager {
    func putProfile(_ parameters: PostProfileInput, id: Int, viewController: ProfileOpenViewController) {
        AF.request("\(Constant.BASE_URL)/api/matching/\(id)/profile", method: .post, parameters: parameters, encoder: JSONParameterEncoder.default, headers: ["x-access-token": UserDefaults.standard.string(forKey: "UserJwt") ?? ""])
            .validate()
            .responseDecodable(of: PostProfileResponse.self) { response in
                switch response.result {
                case .success(let response):
                    viewController.postprofile(result: response)
                    print(response)
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
    }
}
