//
//  ChattingLogPostDataManager.swift
//  BlindCafe
//
//  Created by 권하은 on 2021/11/29.
//

import Alamofire

class ChattingLogPostDataManager {
    func log(_ parameters: RequestMatchingInput, id: Int, viewController: ChattingViewController) {
        AF.request("\(Constant.BASE_URL)/api/matching/\(id)/log", method: .post, parameters: parameters, encoder: JSONParameterEncoder.default, headers: Constant.HEADERS)
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
