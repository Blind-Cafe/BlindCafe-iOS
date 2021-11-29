//
//  GetMatchingResponse.swift
//  BlindCafe
//
//  Created by 권하은 on 2021/11/26.
//

import Foundation

struct GetMatchingResponse: Decodable {
    var matchingId: Int
    var nickname: String
    var profileImage: String?
    var drink: String
    var startTime: String
    var interest: String
    var continuous: Bool
}
