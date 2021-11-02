//
//  UIFont.swift
//  BlindCafe
//
//  Created by 권하은 on 2021/11/02.
//

import Foundation
import UIKit

extension UIFont {
    public enum SpoqaHanSansNeoType: String {
        case bold = "Bold"
        case medium = "Medium"
        case regular = "Regular"
        case light = "Light"
    }

    static func SpoqaSans(_ type: SpoqaHanSansNeoType, size: CGFloat) -> UIFont {
        return UIFont(name: "SpoqaHanSansNeo-\(type.rawValue)", size: size)!
    }
}
