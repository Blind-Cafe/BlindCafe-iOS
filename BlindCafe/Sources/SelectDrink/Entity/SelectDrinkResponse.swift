//
//  SelectDrinkResponse.swift
//  BlindCafe
//
//  Created by κΆνμ on 2021/11/21.
//

import Foundation

struct SelectDrinkResponse: Decodable {
    var code: String
    var message: String
    var startTime: String?
}
