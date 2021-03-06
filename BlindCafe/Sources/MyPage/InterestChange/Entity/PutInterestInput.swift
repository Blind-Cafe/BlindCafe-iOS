//
//  PutInterestInput.swift
//  BlindCafe
//
//  Created by κΆνμ on 2021/11/29.
//

import Foundation

struct PutInterestInput: Encodable {
    var interests: [PutInterestResult]
}

struct PutInterestResult: Encodable {
    var main: Int
    var sub: [String]
}
