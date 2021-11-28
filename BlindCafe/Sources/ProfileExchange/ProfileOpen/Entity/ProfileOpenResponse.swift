//
//  ProfileOpenResponse.swift
//  BlindCafe
//
//  Created by 권하은 on 2021/11/29.
//

import Foundation

struct ProfileOpenResponse: Decodable {
    var fill: Bool
    var userId: Int
    var partnerNickname: String
    var profileImage: String?
    var nickname: String
    var region: String?
    var gender: String
    var interests: [String]
    var age: Int
}
