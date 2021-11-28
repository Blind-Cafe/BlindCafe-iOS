//
//  PostProfileInput.swift
//  BlindCafe
//
//  Created by 권하은 on 2021/11/29.
//

import Foundation

struct PostProfileInput: Encodable {
    var nickname: String
    var state: String
    var region: String
}
