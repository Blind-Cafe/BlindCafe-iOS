//
//  KakaoLoginInput.swift
//  BlindCafe
//
//  Created by 권하은 on 2021/10/27.
//

struct LoginInput: Encodable {
    var platform: String
    var social: String
    var accessToken: String
    var deviceToken: String
}
