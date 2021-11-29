//
//  Leave2ViewController.swift
//  BlindCafe
//
//  Created by 권하은 on 2021/11/26.
//

import UIKit

class Leave2ViewController: UIViewController {

    @IBOutlet weak var leaveReasonLabel: UILabel!
    
    var reasonattr = NSAttributedString(string: "")
    var reason = ""
    
    @IBAction func toHomeButton(_ sender: Any) {
        changeRootViewController(BaseTabBarController())
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if reason != "" {
            leaveReasonLabel.text = reason
        } else {
            leaveReasonLabel.attributedText = reasonattr
        }
       
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
