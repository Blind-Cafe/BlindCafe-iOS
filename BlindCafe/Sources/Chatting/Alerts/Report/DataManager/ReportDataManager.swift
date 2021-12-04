//
//  ReportDataManager.swift
//  BlindCafe
//
//  Created by 권하은 on 2021/11/24.
//

import Alamofire

class ReportDataManager {
    func report(_ parameters: ReportInput, viewController: ReportViewController) {
        AF.request("\(Constant.BASE_URL)/api/report", method: .post, parameters: parameters, encoder: JSONParameterEncoder.default, headers: ["x-access-token": UserDefaults.standard.string(forKey: "UserJwt") ?? ""])
            .validate()
            .responseDecodable(of: ReportResponse.self) { response in
                switch response.result {
                case .success(let response):
                    if response.code == "1000" {
                        viewController.report()
                    }
                    else {
                        viewController.failedToRequest(message: response.message)
                    }
                    print(response)
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
    }
}
