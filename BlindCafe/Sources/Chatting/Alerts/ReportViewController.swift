//
//  ReportViewController.swift
//  BlindCafe
//
//  Created by 권하은 on 2021/11/07.
//

import UIKit

class ReportViewController: UIViewController {
    
    @IBOutlet var reportButtons: [UIButton]!
    
    var indexOfOneAndOnly: Int?
    @IBAction func reportButtonSelected(_ sender: UIButton) {
        if indexOfOneAndOnly != nil {
            if !sender.isSelected {
                for index in reportButtons.indices {
                    reportButtons[index].isSelected = false
                }
                sender.isSelected = true
                indexOfOneAndOnly = reportButtons.firstIndex(of: sender)
                reportNextButton.isEnabled = true
            }
            else {
                sender.isSelected = false
                indexOfOneAndOnly = nil
                reportNextButton.isEnabled = false
            }
        }
        else {
            sender.isSelected = true
            indexOfOneAndOnly = reportButtons.firstIndex(of: sender)
            reportNextButton.isEnabled = true
        }
    }
    
    @IBAction func dismissButton(_ sender: Any) {
        self.dismiss(animated: false, completion: nil)
    }
    
    @IBOutlet weak var reportNextButton: UIButton!
    @IBAction func reportNextButton(_ sender: Any) {
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        reportNextButton.isEnabled = false
    }

}
