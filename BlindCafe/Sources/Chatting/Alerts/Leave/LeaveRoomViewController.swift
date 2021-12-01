//
//  LeaveRoomViewController.swift
//  BlindCafe
//
//  Created by 권하은 on 2021/11/22.
//

import UIKit

class LeaveRoomViewController: BaseViewController {

    @IBOutlet weak var leaveLabel: UILabel!
    var partnerName: String = ""
    var matchingId : Int = 0
    
    @IBAction func dismissButton(_ sender: Any) {
        self.dismiss(animated: false, completion: nil)
    }
    
    @IBAction func leaveButton(_ sender: Any) {
        let rootView = presentingViewController
        
        self.dismiss(animated: false, completion: {
            let childVC2 = LeaveRoom2ViewController()
            childVC2.modalPresentationStyle = .overCurrentContext
            childVC2.matchingId = self.matchingId
            rootView?.present(childVC2, animated: false, completion: nil)
        })

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor(hex: 0x000000, alpha: 0.5)
        leaveLabel.text = "지금 나가시면 \(partnerName)님과 다시 매칭 될 수 없어요 "
    }



}
