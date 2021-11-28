//
//  ImageTopicTableViewCell.swift
//  BlindCafe
//
//  Created by 권하은 on 2021/11/28.
//

import UIKit

class ImageTopicTableViewCell: UITableViewCell {

    @IBOutlet weak var imageTopicImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundColor = .mainBlack
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
