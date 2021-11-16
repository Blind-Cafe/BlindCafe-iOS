//
//  TasteViewController.swift
//  BlindCafe
//
//  Created by 권하은 on 2021/10/30.
//

import UIKit

class InitInterestViewController: BaseOnboardingViewController {
    
    var selectedButtons: Int = 0
    var selectedList: [String] = []
    
    @IBOutlet var tasteButtons: [UIButton]!
    
    @IBAction func tasteAction(_ sender: UIButton) {
        if sender.isSelected {
            sender.isSelected = false
            sender.tintColor = .buttonTint
            selectedButtons -= 1
            selectedList.removeAll(where: { $0 == String(sender.tag) })
        }
        else {
            sender.isSelected = true
            sender.tintColor = .mainGreen
            selectedButtons += 1
            selectedList.append("\(sender.tag)")
        }

        if selectedButtons == 3 {
            nextButton.setImage(UIImage(named: "profileenabled"), for: .normal)
        }
        else {
            nextButton.setImage(UIImage(named: "profilenextbutton"), for: .normal)
        }
        print(selectedList)
    }
    
    @IBOutlet weak var nextButton: UIButton!
    @IBAction func nextButtonTapped(_ sender: Any) {
        if selectedButtons == 0 {
            self.presentBottomAlert(name: "profile1error")
        }
        else if selectedButtons == 3 {
            
            let vc = InitDetailInterestViewController()
            vc.selectedList = selectedList
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nextButton.setImage(UIImage(named: "profilenextbutton"), for: .normal)
        
        setBackButton()
        for i in 0...8 {
            tasteButtons[i].tag = i + 1
        }
    }

}


