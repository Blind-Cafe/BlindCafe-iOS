//
//  MyPageDataManager.swift
//  BlindCafe
//
//  Created by 권하은 on 2021/11/16.
//

import Alamofire

class MyPageDataManager {
    func requestMyPage(viewController: MyPageViewController) {
        AF.request("\(Constant.BASE_URL)/api/user", method: .get, parameters: nil, headers: ["x-access-token": UserDefaults.standard.string(forKey: "UserJwt") ?? ""])
            .validate()
            .responseDecodable(of: MyPageResponse.self) { response in
                switch response.result {
                case .success(let response):
                    viewController.request(result: response)
                    print(response)
                case .failure(let error):
                    print(error.localizedDescription)
                }
                
            }
    }
}
