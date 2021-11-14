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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        backgroundColor = .mainBlack
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
