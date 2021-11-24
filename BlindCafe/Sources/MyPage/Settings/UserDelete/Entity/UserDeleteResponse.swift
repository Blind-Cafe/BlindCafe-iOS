//
//  UserDeleteResponse.swift
//  BlindCafe
//
//  Created by 권하은 on 2021/11/24.
//

import Foundation

struct UserDeleteResponse: Decodable {
    var code: String
    var message: String
    var nickname: String
}
