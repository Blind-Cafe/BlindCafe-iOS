//
//  KakaoLoginResponse.swift
//  BlindCafe
//
//  Created by κΆνμ on 2021/10/27.
//

struct LoginResponse: Decodable {
    var code: String
    var message: String
    var jwt: String?
    var id: Int?
    var nickname: String?
}

