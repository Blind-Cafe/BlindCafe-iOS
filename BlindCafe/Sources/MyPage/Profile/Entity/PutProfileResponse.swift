//
//  PutProfileResponse.swift
//  BlindCafe
//
//  Created by κΆνμ on 2021/11/27.
//

import Foundation

struct PutProfileResponse : Decodable {
    var nickname: String
    var age: Int
    var myGender: String
    var partnerGender: String
    var region: String
}
