//
//  InitDetailInterestViewController.swift
//  BlindCafe
//
//  Created by 권하은 on 2021/11/13.
//

import UIKit

class InitDetailInterestViewController: BaseOnboardingViewController {
    @IBOutlet weak var scrollView: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //scrollView.contentInsetAdjustmentBehavior = .never
        setBackButton()
    }

}

extension InitDetailInterestViewController {
    func getInterest(result: InterestResponse) {
        dismissIndicator()
        
    }
    
    func failedToRequest(message: String) {
        dismissIndicator()
        presentAlert(message: message)
    }
}
