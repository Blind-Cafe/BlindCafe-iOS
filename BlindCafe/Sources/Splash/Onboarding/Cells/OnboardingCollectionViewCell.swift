//
//  OnboardingCollectionViewCell.swift
//  BlindCafe
//
//  Created by κΆνμ on 2021/10/25.
//

import UIKit

class OnboardingCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var onboardingImage: UIImageView!
    @IBOutlet weak var onboardingLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        backgroundColor = .mainBlack
    }

}
