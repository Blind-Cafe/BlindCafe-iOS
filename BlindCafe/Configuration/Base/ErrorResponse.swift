//
//  ErrorResponse.swift
//  BlindCafe
//
//  Created by κΆνμ on 2021/11/28.
//

import Foundation

struct ErrorResponse: Decodable {
    var code: String
    var message: String
}
