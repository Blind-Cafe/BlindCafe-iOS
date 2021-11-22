//
//  LeaveRoomViewController.swift
//  BlindCafe
//
//  Created by 권하은 on 2021/11/22.
//

import UIKit

class LeaveRoomViewController: BaseViewController {

    @IBOutlet weak var leaveLabel: UILabel!
    
    @IBAction func dismissButton(_ sender: Any) {
        self.dismiss(animated: false, completion: nil)
    }
    
    @IBAction func leaveButton(_ sender: Any) {
        let rootView = presentingViewController
        
        self.dismiss(animated: false, completion: {
            let childVC2 = LeaveRoom2ViewController()
            childVC2.modalPresentationStyle = .overCurrentContext
            rootView?.present(childVC2, animated: false, completion: nil)
        })

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor(hex: 0x000000, alpha: 0.5)
    }



}
