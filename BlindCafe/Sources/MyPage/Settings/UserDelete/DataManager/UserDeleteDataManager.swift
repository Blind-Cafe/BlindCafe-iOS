//
//  UserDeleteDataManager.swift
//  BlindCafe
//
//  Created by 권하은 on 2021/11/24.
//

import Alamofire

class UserDeleteDataManager {
    func delete(id: Int, viewController: UserDelete2ViewController) {
        AF.request("\(Constant.BASE_URL)/api/user?reason=\(id)", method: .delete, headers: ["x-access-token": UserDefaults.standard.string(forKey: "UserJwt") ?? ""])
            .validate()
            .responseDecodable(of: UserDeleteResponse.self) { response in
                switch response.result {
                case .success(let response):
                    if response.code == "1000" {
                        viewController.deleted()
                    } else {
                        viewController.failedToRequest(message: response.message)
                    }
                    print(response)
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
    }
}
