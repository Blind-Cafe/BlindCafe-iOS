//
//  UIStackView.swift
//  BlindCafe
//
//  Created by 권하은 on 2021/11/13.
//

import UIKit

extension UIStackView {
    func removeFully(view: UIImageView) {
        removeArrangedSubview(view)
        view.removeFromSuperview()
    }
    
    func removeFullyAllArrangedSubviews() {
        arrangedSubviews.forEach { (view) in
            removeFully(view: view as! UIImageView)
        }
    }
}
