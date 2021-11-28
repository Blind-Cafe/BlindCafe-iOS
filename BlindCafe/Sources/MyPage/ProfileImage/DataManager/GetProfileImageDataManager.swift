//
//  GetProfileImageDataManager.swift
//  BlindCafe
//
//  Created by 권하은 on 2021/11/28.
//

import Alamofire

class GetProfileImageDataManager {
    func getProfileImage(viewController: ProfileImageViewController) {
        AF.request("\(Constant.BASE_URL)/api/user/profile", method: .get, headers: Constant.HEADERS)
            .validate()
            .responseDecodable(of: GetProfileResponse.self) { response in
                switch response.result {
                case .success(let response):
                    viewController.getImages(result: response)
                    print(response)
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
    }
}
