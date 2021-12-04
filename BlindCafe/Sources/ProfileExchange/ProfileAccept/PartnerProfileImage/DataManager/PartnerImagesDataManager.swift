//
//  PartnerImageDataManager.swift
//  BlindCafe
//
//  Created by 권하은 on 2021/11/30.
//

import Alamofire
import SwiftyJSON

class PartnerImagesDataManager {
    func requestHome(id: Int, viewController: PartnerProfileImageViewController) {
        AF.request("\(Constant.BASE_URL)/api/user/\(id)/image", method: .get, parameters: nil, headers: ["x-access-token": UserDefaults.standard.string(forKey: "UserJwt") ?? ""])
            .validate()
            .responseDecodable(of: PartnerImageResponse.self) { response in
                switch response.result {
                case .success(let response):
                    viewController.getImage(result: response)
                    print(response)
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
    }
}
