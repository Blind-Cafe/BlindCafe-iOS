//
//  UserDeleteResponse.swift
//  BlindCafe
//
//  Created by κΆνμ on 2021/11/24.
//

import Foundation

struct UserDeleteResponse: Decodable {
    var code: String
    var message: String
    var nickname: String
}
