//
//  UIImage.swift
//  BlindCafe
//
//  Created by 권하은 on 2021/11/12.
//

import Foundation
import UIKit

extension UIImage {
    func getCropRatio() -> CGFloat {
        let widthRatio = self.size.width / self.size.height
        
        return widthRatio
    }
}
