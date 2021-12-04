//
//  RejectProfileDataManager.swift
//  BlindCafe
//
//  Created by 권하은 on 2021/11/29.
//

import Alamofire

class RejectProfileDataManager {
    func rejectProfile(id: Int, reason: Int, viewController: RejectReasonViewController) {
        AF.request("\(Constant.BASE_URL)/api/matching/\(id)/partner?reason=\(reason)", method: .delete, headers: ["x-access-token": UserDefaults.standard.string(forKey: "UserJwt") ?? ""])
            .validate()
            .response() { response in
                switch response.result {
                case .success(let response):
                    viewController.reject()
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
    }
}
