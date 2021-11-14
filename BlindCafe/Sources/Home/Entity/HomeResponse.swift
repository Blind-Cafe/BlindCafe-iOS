//
//  HomeResponse.swift
//  BlindCafe
//
//  Created by 권하은 on 2021/11/13.
//

import Foundation

struct HomeResponse: Decodable {
    var code: String
    var message: String
    var matchingStatus: String
    var matchingId: Int?
    var partnerId: Int?
    var partnerNickname: String?
    var startTime: Int?
    var reason: String?
}
