//
//  PolicyViewController.swift
//  BlindCafe
//
//  Created by 권하은 on 2021/10/26.
//

import UIKit

class AgreementViewController: BaseOnboardingViewController {

    @IBOutlet weak var checkbox1: UIButton!
    @IBOutlet weak var checkbox2: UIButton!
    @IBOutlet weak var checkbox3: UIButton!
    @IBOutlet weak var checkbox4: UIButton!
    @IBOutlet weak var okayButton: UIButton!
    
    @IBAction func checkBoxTapped(_ sender: UIButton) {
        if sender.isSelected {
            sender.isSelected = false
            okayButton.isEnabled = false
        } else {
            sender.isSelected = true
            if checkbox1.isSelected && checkbox2.isSelected && checkbox4.isSelected && checkbox4.isSelected {
                okayButton.isEnabled = true
            }
        }
    }
    
    @IBAction func okayButton(_ sender: Any) {
        navigationController?.pushViewController(
            InitInterestViewController(), animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        okayButton.isEnabled = false
    }

}
