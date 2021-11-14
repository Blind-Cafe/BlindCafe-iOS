//
//  ProfileInit3ViewController.swift
//  BlindCafe
//
//  Created by 권하은 on 2021/11/02.
//

import UIKit

class InitNicknameViewController: BaseOnboardingViewController {

    @IBOutlet weak var nicknameImage: UIImageView!
    @IBOutlet weak var nicknameTextField: UITextField!
    
    @IBOutlet weak var LetterCount: UIImageView!
    
    @IBOutlet var partnerGenderButtons: [UIButton]!
    
    var indexOfOneAndOnly: Int?
    @IBAction func partnerGenderSelect(_ sender: UIButton) {
        if indexOfOneAndOnly != nil {
            if !sender.isSelected {
                for index in partnerGenderButtons.indices {
                    partnerGenderButtons[index].isSelected = false
                }
                sender.isSelected = true
                indexOfOneAndOnly = partnerGenderButtons.firstIndex(of: sender)
            }
            else {
                sender.isSelected = false
                indexOfOneAndOnly = nil
            }
        }
        else {
            sender.isSelected = true
            indexOfOneAndOnly = partnerGenderButtons.firstIndex(of: sender)
        }
    }
    
    @IBOutlet weak var nextButton: UIButton!
    @IBAction func nextButton(_ sender: Any) {
        var isSelected: Bool = false
        for index in partnerGenderButtons.indices {
            if partnerGenderButtons[index].isSelected == true {
                isSelected = true
            }
        }
        let count = nicknameTextField.text?.count ?? 0
        if nicknameTextField.text == "" {
            presentBottomAlert(name: "nicknameerror")
        }
        else if count < 1 || count > 9 {
            LetterCount.image = UIImage(named: "nicknamealert")
            nicknameImage.image = UIImage(named: "nicknameerrorfield")
        }
        else if isSelected == false {
            presentBottomAlert(name: "genderfirst")
        }
        else {
            navigationController?.pushViewController(InitInterestViewController(), animated: true)
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nicknameTextField.font = .SpoqaSans(.regular, size: 13)
        nicknameTextField.addDoneButtonOnKeyboard()
        nicknameTextField.addTarget(self, action: #selector(ifFocused), for: .touchDown)
        
        setBackButton()
    }
    
    @objc func ifFocused() {
        LetterCount.image = UIImage(named: "nickname")
        nicknameImage.image = UIImage(named: "nicknamefieldfocused")
    }
}
