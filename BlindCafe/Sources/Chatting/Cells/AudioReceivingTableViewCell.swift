//
//  AudioReceivingTableViewCell.swift
//  BlindCafe
//
//  Created by 권하은 on 2021/11/19.
//

import UIKit

class AudioReceivingTableViewCell: UITableViewCell {
    @IBOutlet weak var playstopButton: PlayStopButton!
    @IBOutlet weak var audioTimeLabel: UILabel!
    
    
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
