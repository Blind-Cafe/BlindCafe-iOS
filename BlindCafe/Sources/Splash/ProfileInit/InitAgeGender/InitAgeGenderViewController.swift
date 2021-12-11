//
//  ProfileInit2ViewController.swift
//  BlindCafe
//
//  Created by 권하은 on 2021/11/01.
//

import UIKit

class InitAgeGenderViewController: BaseOnboardingViewController {

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
        
        if indexOfOneAndOnly != nil && ageTextField.text != "" {
            nextButton.isEnabled = true
        }
        else {
            nextButton.isEnabled = false
        }
    }
    
    @IBOutlet weak var nextButton: UIButton!
    @IBAction func nextButton(_ sender: Any) {
        let age: String = ageTextField.text ?? ""
        if age == "" {
             presentBottomAlert(message: "나이를 먼저 설정해주세요.")
        }
        else if Int(age)! < 18 {
            agealert.isHidden = false
            ageImage.image = UIImage(named: "ageerror")
        }
        else if femaleButton.isSelected == false && maleButton.isSelected == false {
            presentBottomAlert(message: "성별을 먼저 선택해주세요.")
        }
        else {
            UserDefaults.standard.set(Int(ageTextField.text!), forKey: "UserAge")
            if genderButtons[0].isSelected == true {
                UserDefaults.standard.set("F", forKey: "UserGender")
            }
            else {
                UserDefaults.standard.set("M", forKey: "UserGender")
            }
            navigationController?.pushViewController(InitNicknameViewController(), animated: true)
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        agealert.isHidden = true
        ageTextField.font = .SpoqaSans(.regular, size: 17)
        //ageTextField.addDoneButtonOnKeyboard()
        ageTextField.addTarget(self, action: #selector(ifFocused), for: .touchDown)
        ageTextField.delegate = self
        
        dismissKeyboardWhenTappedAround()
        nextButton.isEnabled = false
        
        setBackButton()
    }
    
    @objc func ifFocused() {
        agealert.isHidden = true
        ageImage.image = UIImage(named: "agefocused")
    }
    
    @IBAction func textDidChanged(_ sender: Any) {
        ageTextField.checkMaxLength(textField: ageTextField, maxLength: 2)
        
        if indexOfOneAndOnly != nil && ageTextField.text != "" {
            nextButton.isEnabled = true
        }
        else {
            nextButton.isEnabled = false
        }
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
