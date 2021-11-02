//
//  ProfileInit2ViewController.swift
//  BlindCafe
//
//  Created by 권하은 on 2021/11/01.
//

import UIKit

class InitAgeGenderViewController: BaseViewController {

    @IBOutlet weak var ageImage: UIImageView!
    @IBOutlet weak var ageTextField: UITextField!
    @IBOutlet weak var agealert: UIImageView!
    
    @IBOutlet weak var femaleButton: UIButton!
    @IBOutlet weak var maleButton: UIButton!
    
    @IBOutlet var genderButtons: [UIButton]!
    
    var indexOfOneAndOnly: Int?
    @IBAction func genderSelect(_ sender: UIButton) {
        if indexOfOneAndOnly != nil {
            if !sender.isSelected {
                for index in genderButtons.indices {
                    genderButtons[index].isSelected = false
                }
                sender.isSelected = true
                indexOfOneAndOnly = genderButtons.firstIndex(of: sender)
            }
            else {
                sender.isSelected = false
                indexOfOneAndOnly = nil
            }
        }
        else {
            sender.isSelected = true
            indexOfOneAndOnly = genderButtons.firstIndex(of: sender)
        }
    }
    
    @IBOutlet weak var nextButton: UIButton!
    @IBAction func nextButton(_ sender: Any) {
        let age: String = ageTextField.text ?? ""
        if age == "" {
             presentBottomAlert(name: "agefirst")
        }
        else if Int(age)! < 18 {
            agealert.isHidden = false
            ageImage.image = UIImage(named: "ageerror")
        }
        else if femaleButton.isSelected == false && maleButton.isSelected == false {
            presentBottomAlert(name: "genderfirst")
        }
        else {
            navigationController?.pushViewController(InitNicknameViewController(), animated: true)
        }
        
    }
    
    @IBAction func backButton(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        agealert.isHidden = true
        ageTextField.font = .SpoqaSans(.regular, size: 17)
        ageTextField.addDoneButtonOnKeyboard()
        ageTextField.addTarget(self, action: #selector(ifFocused), for: .touchDown)
        ageTextField.delegate = self
    }
    
    @objc func ifFocused() {
        agealert.isHidden = true
        ageImage.image = UIImage(named: "agefocused")
    }
    
    @IBAction func textDidChanged(_ sender: Any) {
        ageTextField.checkMaxLength(textField: ageTextField, maxLength: 2)
    }
    
    @IBAction func doneEditing(_ sender: Any) {
        ageImage.image = UIImage(named: "agedone")
    }
}

extension InitAgeGenderViewController : UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text else { return false }
        
        if text.count >= 2 && range.length == 0 && range.location < 2 {
            return false
        }
        
        return true
    }
}
