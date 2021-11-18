//
//  UIColor.swift
//  BlindCafe
//
//  Created by 권하은 on 2021/10/27.
//

import UIKit

extension UIColor {
    // MARK: hex code를 이용하여 정의
    // ex. UIColor(hex: 0xF5663F)
    convenience init(hex: UInt, alpha: CGFloat = 1.0) {
        self.init(
            red: CGFloat((hex & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((hex & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(hex & 0x0000FF) / 255.0,
            alpha: CGFloat(alpha)
        )
    }
    
    // MARK: 메인 테마 색 또는 자주 쓰는 색을 정의
    // ex. label.textColor = .mainOrange
    class var mainOrange: UIColor { UIColor(hex: 0xFF7100) }
    class var mainBlack: UIColor { UIColor(hex: 0x2d2d2d) }
    class var mainGreen: UIColor { UIColor(hex: 0xbbd2b6) }
    class var black2: UIColor { UIColor(hex: 0x373737) }
    class var charcol: UIColor { UIColor(hex: 0x48484a) }
    class var pale: UIColor { UIColor(hex: 0xf8ede3) }
    class var lightsage: UIColor { UIColor(hex: 0xcfd5c3) }
    class var veryLightPink: UIColor { UIColor(hex: 0xf3f3f3) }
    class var buttonTint: UIColor { UIColor(hex: 0x5b5b5b) }
    class var brownGray: UIColor { UIColor(hex: 0x474747) }
    class var grayishBrown: UIColor { UIColor(hex: 0x454545) }
    class var lightPink: UIColor {UIColor(hex: 0xbdbdbd)}
    class var black3: UIColor {UIColor(hex: 0x323232)}
    class var white2: UIColor { UIColor(hex: 0xfafafa) }
    class var blueGray: UIColor { UIColor(hex: 0x8e8e93)}
}
