//
//  MatchingResponse.swift
//  BlindCafe
//
//  Created by 권하은 on 2021/11/17.
//

import Foundation

struct MatchingResponse: Decodable {
    var matchings: [MatchingResultResponse]?
}

struct MatchingResultResponse: Decodable {
    var matchingId: Int
    var partner: PartnerResultResponse
    var latestMessage: String
    var received: Bool
    var expiryTime: String
}

struct PartnerResultResponse: Decodable {
    var userId: Int
    var profileImage: String
    var nickname: String
}
