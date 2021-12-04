//
//  Constant.swift
//  BlindCafe
//
//  Created by 권하은 on 2021/10/27.
//

import Alamofire

struct Constant {
    static let BASE_URL = "https://www.blindcafe.me"
    
    static var HEADERS: HTTPHeaders = ["x-access-token": UserDefaults.standard.string(forKey: "UserJwt") ?? ""]
}
