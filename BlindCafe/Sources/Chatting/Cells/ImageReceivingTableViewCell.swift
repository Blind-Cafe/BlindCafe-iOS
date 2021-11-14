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
