//
//  ReportListResponse.swift
//  BlindCafe
//
//  Created by 권하은 on 2021/11/25.
//

import Foundation

struct ReportListResponse: Decodable {
    var reports: [ReportListResult]
}

struct ReportListResult: Decodable {
    var date: String
    var target: String
    var reason: String
    var status: String
}
