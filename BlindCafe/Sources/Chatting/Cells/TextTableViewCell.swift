//
//  ReceivingTableViewCell.swift
//  BlindCafe
//
//  Created by 권하은 on 2021/11/05.
//

import UIKit

class TextTableViewCell: UITableViewCell {

    @IBOutlet weak var receivingMessageView: UIImageView!
    @IBOutlet weak var receivingStackView: UIStackView!
    @IBOutlet weak var receivingMessageLabel: UILabel!
    @IBOutlet weak var receivingTime: UILabel!
    @IBOutlet weak var receivingTopConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var sendingMessageView: UIImageView!
    @IBOutlet weak var sendingStackView: UIStackView!
    @IBOutlet weak var sendingMessageLabel: UILabel!
    @IBOutlet weak var sendingTime: UILabel!
    @IBOutlet weak var sendingTopConstraint: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
