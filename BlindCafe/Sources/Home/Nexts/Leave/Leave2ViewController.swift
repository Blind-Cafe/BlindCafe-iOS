//
//  Leave2ViewController.swift
//  BlindCafe
//
//  Created by 권하은 on 2021/11/26.
//

import UIKit

class Leave2ViewController: UIViewController {

    @IBOutlet weak var leaveReasonLabel: UILabel!
    
    var reason = ""
    var partnerName = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let attributedstr = NSMutableAttributedString(string: reason)
        attributedstr.addAttribute(.foregroundColor, value: UIColor.blue, range: (reason as NSString).range(of: reason))
        attributedstr.addAttribute(.foregroundColor, value: UIColor(hex: 0xb1d0b7), range: (reason as NSString).range(of: reason))
        
        leaveReasonLabel.text = "\(attributedstr)"
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
