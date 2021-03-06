//
//  Key.swift
//  BlindCafe
//
//  Created by κΆνμ on 2021/10/21.
//

import Foundation

struct KakaoKey {
    static let KAKAO_NATIVE_KEY = "f4a781581a8f173ba8a4abeae3eb80a6"
}

struct Token {
    static var jwtToken: String = UserDefaults.standard.string(forKey: "UserJwt") ?? ""
}
