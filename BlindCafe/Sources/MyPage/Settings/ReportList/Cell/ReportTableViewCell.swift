//
//  ReportTableViewCell.swift
//  BlindCafe
//
//  Created by κΆνμ on 2021/11/25.
//

import UIKit

class ReportTableViewCell: UITableViewCell {

    @IBOutlet weak var reportLabel1: UILabel!
    @IBOutlet weak var reportLabel2: UILabel!
    @IBOutlet weak var TimeLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
