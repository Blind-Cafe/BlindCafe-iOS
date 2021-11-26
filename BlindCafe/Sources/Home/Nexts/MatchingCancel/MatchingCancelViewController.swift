//
//  MatchingCancelViewController.swift
//  BlindCafe
//
//  Created by 권하은 on 2021/11/26.
//

import UIKit

class MatchingCancelViewController: UIViewController {

    @IBAction func dismissButton(_ sender: Any) {
        dismiss(animated: false, completion: nil)
    }
    @IBAction func matchingCancelButton(_ sender: Any) {
        showIndicator()
        let input = MatchingCancelInput()
        MatchingCancelDataManager().matchingCancel(input, viewController: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
}

extension MatchingCancelViewController {
    func cancel(){
        dismissIndicator()
        self.dismiss(animated: false, completion: nil)
    }
    
    func failedToRequest(message: String) {
        dismissIndicator()
        presentAlert(message: message)
    }
}
