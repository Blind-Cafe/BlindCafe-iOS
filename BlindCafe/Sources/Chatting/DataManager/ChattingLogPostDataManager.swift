//
//  ChattingLogPostDataManager.swift
//  BlindCafe
//
//  Created by κΆνμ on 2021/11/29.
//

import Alamofire

class ChattingLogPostDataManager {
    func log(_ parameters: RequestMatchingInput, id: Int, viewController: ChattingViewController) {
        AF.request("\(Constant.BASE_URL)/api/matching/\(id)/log", method: .post, parameters: parameters, encoder: JSONParameterEncoder.default, headers: ["x-access-token": UserDefaults.standard.string(forKey: "UserJwt") ?? ""])
            .validate()
            .response() { response in
                switch response.result {
                case .success(_):
                    viewController.chatLog()
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
    }
}
