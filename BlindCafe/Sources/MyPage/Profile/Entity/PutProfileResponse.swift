//
//  PutProfileResponse.swift
//  BlindCafe
//
//  Created by 권하은 on 2021/11/27.
//

import Foundation

struct PutProfileResponse : Decodable {
    var nickname: String
    var age: Int
    var myGender: String
    var partnerGender: String
    var region: String
}
