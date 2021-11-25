//
//  ReportListDataManager.swift
//  BlindCafe
//
//  Created by 권하은 on 2021/11/25.
//

import Alamofire

class ReportListDataManager {
    func getReportList(viewController: ReportListViewController) {
        AF.request("\(Constant.BASE_URL)/api/report", method: .get, headers: Constant.HEADERS)
            .validate()
            .responseDecodable(of: ReportListResponse.self) { response in
                switch response.result {
                case .success(let response):
                    viewController.getReport(result: response)
                    print(response)
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
    }
}
