//
//  MatchedSendDataManager.swift
//  BlindCafe
//
//  Created by 권하은 on 2021/11/29.
//

import Alamofire

class MatchedSendDataManager {
    func postChatting(_ parameters: PostChattingInput, id: Int, viewController: MatchedChattingViewController) {
        AF.request("\(Constant.BASE_URL)/api/chat/\(id)", method: .post, parameters: parameters, encoder: JSONParameterEncoder.default, headers: ["x-access-token": UserDefaults.standard.string(forKey: "UserJwt") ?? ""])
            .validate()
            .response() { response in
                switch response.result {
                case .success(let response):
                    viewController.send()
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
    }
}
