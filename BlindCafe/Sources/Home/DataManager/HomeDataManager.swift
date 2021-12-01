//
//  HomeDataManager.swift
//  BlindCafe
//
//  Created by 권하은 on 2021/11/13.
//

import Alamofire
import SwiftyJSON

class HomeDataManager {
    func requestHome(viewController: HomeViewController) {
        AF.request("\(Constant.BASE_URL)/api/user/home", method: .get, parameters: nil, headers: Constant.HEADERS)
            .validate()
            .responseDecodable(of: HomeResponse.self) { response in
                switch response.result {
                case .success(let response):
                    if response.code == "1000" {
                        viewController.requestData(result: response)
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                    if response.response!.statusCode >= 400 && response.response!.statusCode < 500 {
                        viewController.dismissIndicator()
                        if let data = response.data {
                            let json = try? JSON(data: data)
                            
                            if let code: String = json?["code"].stringValue {
                                if code == "1007" {
                                    viewController.stopUser()
                                }
                            }
                        }
                    }
                }
            }
    }
}
