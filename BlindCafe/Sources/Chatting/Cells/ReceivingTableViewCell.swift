//
//  ReceivingTableViewCell.swift
//  BlindCafe
//
//  Created by 권하은 on 2021/11/05.
//

import UIKit

class ReceivingTableViewCell: UITableViewCell {

    @IBOutlet weak var message: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        
        backgroundColor = .mainBlack
        message.sizeToFit()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
