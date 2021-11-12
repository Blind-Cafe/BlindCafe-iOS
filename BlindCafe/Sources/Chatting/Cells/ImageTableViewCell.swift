//
//  ImageTableViewCell.swift
//  BlindCafe
//
//  Created by 권하은 on 2021/11/11.
//

import UIKit

class ImageTableViewCell: UITableViewCell {

    @IBOutlet weak var receivingImageView: UIImageView!
    @IBOutlet weak var receivingTime: UILabel!
    
    @IBOutlet weak var sendingImageView: UIImageView!
    @IBOutlet weak var sendingTime: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()

        backgroundColor = .mainBlack
        receivingImageView.cornerRadius = 10
        sendingImageView.cornerRadius = 10
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    /*func setwidthheight(width: CGFloat, height: CGFloat) {
        if height >= width {
            sendingImageView.frame = CGRect(x: sendingImageView.frame.origin.x, y: sendingImageView.frame.origin.y, width: width / height * 234, height: 234)
            receivingImageView.frame = CGRect(x: receivingImageView.frame.origin.x, y: receivingImageView.frame.origin.y, width: width / height * 234, height: 234)
        }
        else {
            sendingImageView.frame = CGRect(x: sendingImageView.frame.origin.x, y: sendingImageView.frame.origin.y, width: width / height * 234, height: 234)
            receivingImageView.frame = CGRect(x: receivingImageView.frame.origin.x, y: receivingImageView.frame.origin.y, width: width / height * 234, height: 234)
        }
    }*/
    
    override func layoutSubviews() {
        super.layoutSubviews()
        //sendingImageView.sizeToFit()
        //receivingImageView.sizeToFit()
    }
}
