//
//  SendingTableViewCell.swift
//  BlindCafe
//
//  Created by 권하은 on 2021/11/05.
//

import UIKit

class SendingTableViewCell: UITableViewCell {
    @IBOutlet weak var messageView: UIImageView!
    @IBOutlet weak var message: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    
    @IBOutlet weak var topConstraint: NSLayoutConstraint!
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
