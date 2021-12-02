//
//  DeleteProfileImageDataManager.swift
//  BlindCafe
//
//  Created by 권하은 on 2021/11/29.
//

import Alamofire

class DeleteProfileImageDataManager {
    func deleteProfileImage(id: Int, viewController: ProfileImageViewController) {
        AF.request("\(Constant.BASE_URL)/api/user/image?priority=\(id)", method: .delete, headers: Constant.HEADERS)
            .validate()
            .response() { response in
                switch response.result {
                case .success(_):
                    viewController.deleteImage()
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
    }
}
