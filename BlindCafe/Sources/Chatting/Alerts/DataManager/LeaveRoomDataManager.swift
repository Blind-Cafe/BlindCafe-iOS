//
//  LeaveRoomDataManager.swift
//  BlindCafe
//
//  Created by 권하은 on 2021/11/22.
//

import Alamofire

class LeaveRoomDataManager {
    func leaveRoom(id: Int, viewController: LeaveRoom2ViewController) {
        AF.request("\(Constant.BASE_URL)/api/matching/\(id)", method: .delete, headers: Constant.HEADERS)
            .validate()
            .responseDecodable(of: LeaveRoomResponse.self) { response in
                switch response.result {
                case .success(let response):
                    print(response)
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
    }
}
