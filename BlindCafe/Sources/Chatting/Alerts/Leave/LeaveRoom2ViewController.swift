//
//  LeaveRoom2ViewController.swift
//  BlindCafe
//
//  Created by 권하은 on 2021/11/22.
//

import UIKit

class LeaveRoom2ViewController: UIViewController {

    @IBOutlet var leaveRoomButtons: [UIButton]!
    
    var reasonList: [Int] = []
    @IBAction func leaveRoomButton(_ sender: UIButton) {
        if sender.isSelected {
            
        } else {
            
        }
    }
    
    @IBAction func dismissButton(_ sender: Any) {
        dismiss(animated: false, completion: nil)
    }
    
    @IBOutlet weak var byeButton: UIButton!
    @IBAction func byeButton(_ sender: Any) {

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        byeButton.isEnabled = false
        view.backgroundColor = UIColor(hex: 0x000000, alpha: 0.5)
    }

}

extension LeaveRoom2ViewController {
    func leaveRoom() {
        dismissIndicator()
    }
    func failedToRequest(message: String) {
        dismissIndicator()
        presentAlert(message: message)
    }
}
