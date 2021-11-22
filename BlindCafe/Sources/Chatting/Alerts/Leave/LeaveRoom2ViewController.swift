//
//  LeaveRoom2ViewController.swift
//  BlindCafe
//
//  Created by 권하은 on 2021/11/22.
//

import UIKit

class LeaveRoom2ViewController: UIViewController {

    @IBOutlet var leaveRoomButtons: [UIButton]!
    
    var indexOfOneAndOnly: Int?
    @IBAction func leaveRoomButton(_ sender: UIButton) {
        if indexOfOneAndOnly != nil {
            if !sender.isSelected {
                for index in leaveRoomButtons.indices {
                    leaveRoomButtons[index].isSelected = false
                }
                sender.isSelected = true
                indexOfOneAndOnly = leaveRoomButtons.firstIndex(of: sender)
                byeButton.isEnabled = true
            }
            else {
                sender.isSelected = false
                indexOfOneAndOnly = nil
                byeButton.isEnabled = false
            }
        }
        else {
            sender.isSelected = true
            indexOfOneAndOnly = leaveRoomButtons.firstIndex(of: sender)
            byeButton.isEnabled = true
        }
    }
    
    @IBAction func dismissButton(_ sender: Any) {
        dismiss(animated: false, completion: nil)
    }
    
    @IBOutlet weak var byeButton: UIButton!
    @IBAction func byeButton(_ sender: Any) {
        LeaveRoomDataManager().leaveRoom(id: (indexOfOneAndOnly! + 1), viewController: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        byeButton.isEnabled = false
        view.backgroundColor = UIColor(hex: 0x000000, alpha: 0.5)
    }

}

