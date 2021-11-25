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
            sender.isSelected = false
            reasonList.removeAll(where: { $0 == sender.tag })
        } else {
            sender.isSelected = true
            reasonList.append(sender.tag)
        }
        
        if reasonList.count != 0 {
            byeButton.isEnabled = true
        }
        else {
            byeButton.isEnabled = false
        }
        
        print(reasonList)
    }
    
    @IBAction func dismissButton(_ sender: Any) {
        dismiss(animated: false, completion: nil)
    }
    
    @IBOutlet weak var byeButton: UIButton!
    @IBAction func byeButton(_ sender: Any) {
        var str = ""
        for i in 0..<reasonList.count {
            str += "reason=\(String(reasonList[i]))&"
        }
        print(str.dropLast())
        showIndicator()
        LeaveRoomDataManager().leaveRoom(id: String(str.dropLast()), viewController: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        byeButton.isEnabled = false
        view.backgroundColor = UIColor(hex: 0x000000, alpha: 0.5)
        
        for i in 0..<leaveRoomButtons.count {
            leaveRoomButtons[i].tag = i + 1
        }
    }

}

extension LeaveRoom2ViewController {
    func leaveRoom() {
        dismissIndicator()
        changeRootViewController(BaseTabBarController())
    }
    func failedToRequest(message: String) {
        dismissIndicator()
        presentAlert(message: message)
    }
}
