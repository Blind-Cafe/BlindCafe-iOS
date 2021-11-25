//
//  PlayStopButton.swift
//  BlindCafe
//
//  Created by 권하은 on 2021/11/19.
//

import UIKit

class PlayStopButton : UIButton {

    var content : String = ""
    var sending: Bool = true

    convenience init(content: String, sending: Bool, object: Any) {
        self.init()
        self.content = content
        self.sending = sending
    }
}
