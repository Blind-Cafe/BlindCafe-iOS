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
            .validate()
            .responseDecodable(of: GetTopicResponse.self) { response in
                switch response.result {
                case .success(let response):
                    viewController.topic(result: response)
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
    }
}
