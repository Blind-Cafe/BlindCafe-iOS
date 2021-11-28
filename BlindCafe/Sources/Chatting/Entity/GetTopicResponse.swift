//
//  GetTopicResponse.swift
//  BlindCafe
//
//  Created by 권하은 on 2021/11/28.
//

import Foundation

struct GetTopicResponse : Decodable {
    var type: String
    var text: TextTopicResult?
    var image: TopicResult?
    var audio: TopicResult?
}

struct TextTopicResult: Decodable {
    var content: String?
}

struct TopicResult: Decodable {
    var title: String?
    var src: String?
}
