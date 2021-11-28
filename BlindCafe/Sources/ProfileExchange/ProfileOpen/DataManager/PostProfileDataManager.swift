//
//  PostProfileDataManager.swift
//  BlindCafe
//
//  Created by 권하은 on 2021/11/29.
//

import Alamofire

class PostProfileDataManager {
    func putProfile(_ parameters: PostProfileInput, id: Int, viewController: ProfileOpenViewController) {
        AF.request("\(Constant.BASE_URL)/api/matching/\(id)/profile", method: .post, parameters: parameters, encoder: JSONParameterEncoder.default, headers: Constant.HEADERS)
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
