//
//  ImageReceivingTableViewCell.swift
//  BlindCafe
//
//  Created by 권하은 on 2021/11/14.
//

import UIKit

class ImageReceivingTableViewCell: UITableViewCell {

    @IBOutlet weak var receivingImageView: UIImageView!
    @IBOutlet weak var receivingTime: UILabel!
    @IBOutlet weak var receivingHeight: NSLayoutConstraint!
    @IBOutlet weak var receivingWidth: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        backgroundColor = .mainBlack
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let width = receivingImageView.image?.size.width
        let height = receivingImageView.image?.size.height
        
        if width != nil && height != nil {
            if width! >= height! {
                receivingWidth.constant = 234
                receivingHeight.constant = height! / width! * 234
            }
            else {
                receivingWidth.constant = width! / height! * 234
                receivingHeight.constant = 234
            }
        }
    }
    
}
