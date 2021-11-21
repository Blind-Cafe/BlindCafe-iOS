//
//  RequestMatchingResponse.swift
//  BlindCafe
//
//  Created by 권하은 on 2021/11/21.
//

import Foundation

struct RequestMatchingResponse: Decodable {
    var matchingStatus: String
    var matchingId: Int?
    var partnerId: Int?
    var partnerNickname: String?
}
