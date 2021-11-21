//
//  FCMInput.swift
//  BlindCafe
//
//  Created by 권하은 on 2021/11/22.
//

import Foundation

struct FCMInput: Encodable {
    var targetToken: String
    var title: String
    var body: String
    var path: String
}
