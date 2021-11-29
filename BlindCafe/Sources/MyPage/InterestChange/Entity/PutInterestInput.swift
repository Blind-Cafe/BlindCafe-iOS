//
//  PutInterestInput.swift
//  BlindCafe
//
//  Created by 권하은 on 2021/11/29.
//

import Foundation

struct PutInterestInput: Encodable {
    var interests: [PutInterestResult]
}

struct PutInterestResult: Encodable {
    var main: Int
    var sub: [String]
}
