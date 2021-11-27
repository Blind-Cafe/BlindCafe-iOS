//
//  MyPageResponse.swift
//  BlindCafe
//
//  Created by 권하은 on 2021/11/16.
//

import Foundation

struct MyPageResponse: Decodable {
    var profileImage: String?
    var nickname: String
    var myGender: String
    var age: Int
    var region: String?
    var partnerGender: String
    var interests: [Int]
    var drinks: [Int]
}
