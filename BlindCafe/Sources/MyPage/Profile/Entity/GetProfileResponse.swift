//
//  GetProfileResponse.swift
//  BlindCafe
//
//  Created by 권하은 on 2021/11/27.
//

import Foundation

struct GetProfileResponse: Decodable {
    var images: [String]?
    var nickname: String
    var age: Int
    var myGender: String
    var partnerGender: String
    var region: String?
}
