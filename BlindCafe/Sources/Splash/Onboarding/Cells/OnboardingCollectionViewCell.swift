//
//  OnboardingCollectionViewCell.swift
//  BlindCafe
//
//  Created by 권하은 on 2021/10/25.
//

import UIKit

class OnboardingCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var onboardingImage: UIImageView!
    @IBOutlet weak var textImage: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        
        backgroundColor = .mainBlack
    }

}
