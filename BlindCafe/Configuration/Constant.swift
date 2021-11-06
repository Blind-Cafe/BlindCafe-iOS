//
//  Constant.swift
//  BlindCafe
//
//  Created by 권하은 on 2021/10/27.
//

import Alamofire

struct Constant {
    static let BASE_URL = "http://dev.blindcafe.me"
    
    static var HEADERS: HTTPHeaders = ["x-access-token": Token.jwtToken]
}
