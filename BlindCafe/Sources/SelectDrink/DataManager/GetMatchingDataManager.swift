//
//  GetMatchingDataManager.swift
//  BlindCafe
//
//  Created by 권하은 on 2021/11/26.
//

import Alamofire

class GetMatchingDataManager {
    func getMatching(id: Int, viewController: SelectDrinkViewController) {
        AF.request("\(Constant.BASE_URL)/api/matching/\(id)", method: .get, headers: Constant.HEADERS)
            .validate()
            .responseDecodable(of: GetMatchingResponse.self) { response in
                switch response.result {
                case .success(let response):
                    viewController.getDrink(result: response)
                    print(response)
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
    }
}
