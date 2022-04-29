//
//  KakaoLoginResponse.swift
//  BlindCafe
//
//  Created by 권하은 on 2021/10/27.
//

struct LoginResponse: Decodable {
    var uid: Int
    var nickname: String?
    var accessToken: String?
    var refreshToken: String?
}

