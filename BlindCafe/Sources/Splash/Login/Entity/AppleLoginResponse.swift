//
//  AppleLoginResponse.swift
//  BlindCafe
//
//  Created by 권하은 on 2021/10/29.
//

import Foundation

struct AppleLoginResponse: Decodable {
    var code: String
    var message: String
    var jwt: String?
}

