//
//  AudioTopicTableViewCell.swift
//  BlindCafe
//
//  Created by κΆνμ on 2021/11/28.
//

import UIKit

class AudioTopicTableViewCell: UITableViewCell {

    @IBOutlet weak var playStopButton: UIButton!
    @IBOutlet weak var audioSlider: UISlider!
    @IBOutlet weak var audioTimeLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundColor = .mainBlack
        
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

        // Configure the view for the selected state
    }
    
}
