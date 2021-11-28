//
//  GetTopicDataManager.swift
//  BlindCafe
//
//  Created by 권하은 on 2021/11/28.
//

import Alamofire

class GetTopicDataManager {
    func getTopic(id: Int, viewController: ChattingViewController) {
        AF.request("\(Constant.BASE_URL)/api/matching/\(id)/topic", method: .get, headers: Constant.HEADERS)
            .validate(statusCode: 200..<300)
            .responseDecodable(of: GetTopicResponse.self) { response in
                switch response.result {
                case .success(let response):
                    viewController.topic(result: response)
                case .failure(_):
                    viewController.failedToRequest(message: "더 이상 존재하는 토픽이 없습니다.")
                }
            }
    }
}
