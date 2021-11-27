//
//  PutProfileInput.swift
//  BlindCafe
//
//  Created by 권하은 on 2021/11/27.
//

import Foundation

struct PutProfileInput: Encodable {
    var nickname: String
    var partnerGender: String
    var state: String?
    var region: String?
}
