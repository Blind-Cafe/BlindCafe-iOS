//
//  PartnerImageDataManager.swift
//  BlindCafe
//
//  Created by 권하은 on 2021/11/30.
//

import Alamofire

class PartnerImagesDataManager {
    func requestHome(id: Int, viewController: PartnerProfileImageViewController) {
        AF.request("\(Constant.BASE_URL)/api/user/\(id)/image", method: .get, parameters: nil, headers: Constant.HEADERS)
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
