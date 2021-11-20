//
//  PlayStopButton.swift
//  BlindCafe
//
//  Created by 권하은 on 2021/11/19.
//

import UIKit

class PlayStopButton : UIButton {

    var content : String = ""

    convenience init(content: String, object: Any) {
        self.init()
        self.content = content
    }
}
