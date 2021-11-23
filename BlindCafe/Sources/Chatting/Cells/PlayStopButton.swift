//
//  PlayStopButton.swift
//  BlindCafe
//
//  Created by 권하은 on 2021/11/19.
//

import UIKit

class PlayStopButton : UIButton {

    var content : String = ""
    var index: Int = -1
    var timeLabel: UILabel!

    convenience init(content: String, index: Int, timeLabel: UILabel, object: Any) {
        self.init()
        self.content = content
        self.index = index
        self.timeLabel = timeLabel
    }
}
