//
//  MatchedLogDataManager.swift
//  BlindCafe
//
//  Created by 권하은 on 2021/11/29.
//

import Alamofire

class MatchedLogDataManager {
    func log(_ parameters: RequestMatchingInput, id: Int, viewController: MatchedChattingViewController) {
        AF.request("\(Constant.BASE_URL)/api/matching/\(id)/log", method: .post, parameters: parameters, encoder: JSONParameterEncoder.default, headers: ["x-access-token": UserDefaults.standard.string(forKey: "UserJwt") ?? ""])
            .validate()
            .response() { response in
                switch response.result {
                case .success(let response):
                    viewController.chatLog()
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
    }
}
