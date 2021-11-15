//
//  KakaoLoginResponse.swift
//  BlindCafe
//
//  Created by 권하은 on 2021/10/27.
//

struct LoginResponse: Decodable {
    var code: String
    var message: String
    var jwt: String?
    var id: Int?
    var nickname: String?
}

