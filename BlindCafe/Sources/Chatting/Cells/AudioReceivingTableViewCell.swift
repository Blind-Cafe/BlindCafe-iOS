//
//  AudioReceivingTableViewCell.swift
//  BlindCafe
//
//  Created by 권하은 on 2021/11/19.
//

import UIKit

class AudioReceivingTableViewCell: UITableViewCell {
    @IBOutlet weak var playStopButton: PlayStopButton!
    @IBOutlet weak var audioSlider: UISlider!
    @IBOutlet weak var audioTimeLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let thumbView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 10))
        
        thumbView.backgroundColor = .white
        thumbView.layer.cornerRadius = thumbView.frame.height / 2
        
        let renderer = UIGraphicsImageRenderer(bounds: thumbView.bounds)
        
        audioSlider.setThumbImage(renderer.image { context in
            thumbView.layer.render(in: context.cgContext)
        }, for: .normal)
        
        audioSlider.isEnabled = false
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
}
