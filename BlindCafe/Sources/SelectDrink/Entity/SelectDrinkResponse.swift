//
//  SelectDrinkResponse.swift
//  BlindCafe
//
//  Created by 권하은 on 2021/11/21.
//

import Foundation

struct SelectDrinkResponse: Decodable {
    var code: String
    var message: String
    var startTime: String?
}
