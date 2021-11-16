//
//  PostUserInfoInput.swift
//  BlindCafe
//
//  Created by 권하은 on 2021/11/16.
//

import Foundation

struct PostUserInfoInput: Encodable {
    var age: Int
    var myGender: String
    var nickname: String
    var partnerGender: String
    var interests: [PostUserInfoResult]
}

struct PostUserInfoResult: Encodable {
    var main: Int
    var sub: [String]
}
