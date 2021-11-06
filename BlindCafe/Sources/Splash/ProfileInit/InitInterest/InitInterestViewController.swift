//
//  TasteViewController.swift
//  BlindCafe
//
//  Created by 권하은 on 2021/10/30.
//

import UIKit

class InitInterestViewController: BaseViewController {
    
    var selectedButtons: Int = 0
    
    @IBOutlet var tasteButtons: [UIButton]!
    
    @IBAction func tasteAction(_ sender: UIButton) {
        if sender.isSelected {
            sender.isSelected = false
            selectedButtons -= 1
        }
        else {
            sender.isSelected = true
            selectedButtons += 1
        }

        if selectedButtons == 3 {
            nextButton.setImage(UIImage(named: "profileenabled"), for: .normal)
        }
        else {
            nextButton.setImage(UIImage(named: "profilenextbutton"), for: .normal)
        }
    }
    
    @IBOutlet weak var nextButton: UIButton!
    @IBAction func nextButtonTapped(_ sender: Any) {
        if selectedButtons == 0 {
            self.presentBottomAlert(name: "profile1error")
        }
        else if selectedButtons == 3 {
            navigationController?.pushViewController(InitAgeGenderViewController(), animated: true)
        }
    }
    
    
    @IBAction func backButton(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nextButton.setImage(UIImage(named: "profilenextbutton"), for: .normal)
        dismissKeyboardWhenTappedAround()
    }



}
