//
//  Report2ViewController.swift
//  BlindCafe
//
//  Created by 권하은 on 2021/11/22.
//

import UIKit

class Report2ViewController: UIViewController {
    
    @IBAction func leaveRoomButton(_ sender: Any) {
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

}

extension Report2ViewController {
    func failedToRequest(message: String) {
        dismissIndicator()
        presentAlert(message: message)
    }
}
