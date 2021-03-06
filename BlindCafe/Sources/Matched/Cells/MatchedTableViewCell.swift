//
//  MatchedTableViewCell.swift
//  BlindCafe
//
//  Created by κΆνμ on 2021/11/17.
//

import UIKit

class MatchedTableViewCell: UITableViewCell {
    
    @IBOutlet weak var partnerProfile: UIImageView!
    @IBOutlet weak var partnerName: UILabel!
    @IBOutlet weak var lastMessage: UILabel!
    @IBOutlet weak var timeLeft: UILabel!
    @IBOutlet weak var lastMessageImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        backgroundColor = .brownGray
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
