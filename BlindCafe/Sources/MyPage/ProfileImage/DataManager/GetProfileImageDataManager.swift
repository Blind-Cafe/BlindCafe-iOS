//
//  GetProfileImageDataManager.swift
//  BlindCafe
//
//  Created by 권하은 on 2021/11/29.
//

import Alamofire

class GetProfileImageDataManager {
    func getProfileImage(viewController: ProfileImageViewController) {
        AF.request("\(Constant.BASE_URL)/api/user/image", method: .get, headers: ["x-access-token": UserDefaults.standard.string(forKey: "UserJwt") ?? ""])
            .validate()
            .responseDecodable(of: GetProfileImageResponse.self) { response in
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
