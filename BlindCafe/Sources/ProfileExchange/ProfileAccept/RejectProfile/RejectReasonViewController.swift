//
//  RejectReasonViewController.swift
//  BlindCafe
//
//  Created by 권하은 on 2021/11/29.
//

import UIKit

class RejectReasonViewController: BaseViewController {

    var partnerName: String = ""
    @IBOutlet var reasonButtons: [UIButton]!
    var indexOfOneAndOnly: Int? = nil
    @IBAction func reasonButtons(_ sender: UIButton) {
        if indexOfOneAndOnly != nil {
            if !sender.isSelected {
                for index in reasonButtons.indices {
                    reasonButtons[index].isSelected = false
                }
                sender.isSelected = true
                indexOfOneAndOnly = reasonButtons.firstIndex(of: sender)
                rejectButton.isEnabled = true
            }
            else {
                sender.isSelected = false
                indexOfOneAndOnly = nil
                rejectButton.isEnabled = false
            }
        }
        else {
            sender.isSelected = true
            indexOfOneAndOnly = reasonButtons.firstIndex(of: sender)
            rejectButton.isEnabled = true
        }
    }
    
    @IBOutlet weak var rejectButton: UIButton!
    @IBAction func rejectButtons(_ sender: Any) {
        showIndicator()
        RejectProfileDataManager().rejectProfile(id: UserDefaults.standard.integer(forKey: "MatchingId"), reason: indexOfOneAndOnly! + 1, viewController: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        rejectButton.isEnabled = false
        
        let backButton: UIButton = UIButton()
        backButton.setImage(UIImage(named: "backbutton"), for: .normal)
        backButton.addTarget(self, action: #selector(popToVC), for: .touchUpInside)
        backButton.frame = CGRect(x: 18, y: 0, width: 44, height: 44)
        let addBackButton = UIBarButtonItem(customView: backButton)
        
        self.navigationItem.setLeftBarButton(addBackButton, animated: false)
    }
}

extension RejectReasonViewController {
    func reject() {
        dismissIndicator()
        let vc = Leave2ViewController()
        vc.reason = "\(partnerName)님과 3일간의 추억은 즐거우셨나요?\n이제 더 좋은 추억을 쌓으러 가보죠!"
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true, completion: nil)
    }
}
