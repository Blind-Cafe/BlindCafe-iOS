//
//  PostChattingDataManager.swift
//  BlindCafe
//
//  Created by 권하은 on 2021/11/29.
//

import Alamofire

class PostChattingDataManager {
    func postChatting(_ parameters: PostChattingInput, id: Int, viewController: ChattingViewController) {
        AF.request("\(Constant.BASE_URL)/api/chat/\(id)", method: .post, parameters: parameters, encoder: JSONParameterEncoder.default, headers: Constant.HEADERS)
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
