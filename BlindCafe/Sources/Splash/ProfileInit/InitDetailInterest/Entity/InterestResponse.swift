//
//  InterestResponse.swift
//  BlindCafe
//
//  Created by 권하은 on 2021/11/15.
//

import Foundation

struct InterestResponse: Decodable {
    var interests: [InterestResult]?
}

struct InterestResult: Decodable {
    var main: Int
    var sub: [String]
}
