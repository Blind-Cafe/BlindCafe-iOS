//
//  ReportViewController.swift
//  BlindCafe
//
//  Created by 권하은 on 2021/11/07.
//

import UIKit

class ReportViewController: UIViewController {
    
    @IBOutlet var reportButtons: [UIButton]!
    var matchingId: Int = 0
    
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
        let input = ReportInput(matchingId: matchingId, reason: self.indexOfOneAndOnly! + 1)
        showIndicator()
        ReportDataManager().report(input, viewController: self)
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        reportNextButton.isEnabled = false
        view.backgroundColor = UIColor(hex: 0x000000, alpha: 0.5)
    }

}

extension ReportViewController {
    func report() {
        dismissIndicator()
        
        let rootView = presentingViewController
        
        self.dismiss(animated: false, completion: {
            let childVC2 = Report2ViewController()
            childVC2.modalPresentationStyle = .overCurrentContext
            rootView?.present(childVC2, animated: false, completion: nil)
        })
    }
    
    func failedToRequest(message: String) {
        dismissIndicator()
        presentAlert(message: message)
    }
}
