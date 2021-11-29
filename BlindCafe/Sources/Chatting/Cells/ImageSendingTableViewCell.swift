//
//  ImageSendingTableViewCell.swift
//  BlindCafe
//
//  Created by 권하은 on 2021/11/14.
//

import UIKit

class ImageSendingTableViewCell: UITableViewCell {

    @IBOutlet weak var sendingImageView: UIImageView!
    @IBOutlet weak var sendingTime: UILabel!
    @IBOutlet weak var sendingHeight: NSLayoutConstraint!
    @IBOutlet weak var sendingWidth: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layoutIfNeeded()
        
        let width = sendingImageView.image?.size.width
        let height = sendingImageView.image?.size.height
        
        if width != nil && height != nil {
            if width! >= height! {
                sendingWidth.constant = 234
                sendingHeight.constant = height! / width! * 234
            }
            else {
                sendingWidth.constant = width! / height! * 234
                sendingHeight.constant = 234
            }
        }
    }
}
