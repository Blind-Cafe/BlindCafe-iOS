//
//  SelectDrinkDataManager.swift
//  BlindCafe
//
//  Created by 권하은 on 2021/11/21.
//

import Alamofire

class SelectDrinkDataManager {
    func requestDrink (id: Int, _ parameters: SelectDrinkInput, viewController: SelectDrinkViewController) {
        AF.request("\(Constant.BASE_URL)/api/matching/\(id)/drink", method: .post, parameters: parameters, encoder: JSONParameterEncoder.default, headers: Constant.HEADERS)
            .validate()
            .responseDecodable(of: SelectDrinkResponse.self) { response in
                switch response.result {
                case .success(let response):
                    viewController.selectDrink(result: response)
                    print(response)
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
    }
}
