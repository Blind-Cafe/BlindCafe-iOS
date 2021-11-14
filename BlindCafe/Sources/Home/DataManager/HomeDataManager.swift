//
//  HomeDataManager.swift
//  BlindCafe
//
//  Created by 권하은 on 2021/11/13.
//

import Alamofire

class HomeDataManager {
    func requestHome(viewController: HomeViewController) {
        AF.request("\(Constant.BASE_URL)/api/user/home", method: .get, parameters: nil, headers: Constant.HEADERS)
            .validate()
            .responseDecodable(of: HomeResponse.self) { response in
                switch response.result {
                case .success(let response):
                    if response.code == "1000"{
                        viewController.requestData(result: response)
                    }
                    else {
                        viewController.failedToRequest(message: response.message)
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                }
                
            }
    }
}
