//
//  ChattingViewController.swift
//  BlindCafe
//
//  Created by 권하은 on 2021/11/03.
//

import UIKit

class ChattingViewController: BaseViewController {

    @IBAction func backButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBOutlet weak var customToolbar: UIView!
    
    @IBOutlet weak var toolbarBottomConstraint: NSLayoutConstraint!
    var toolbarBottomConstraintInitialValue: CGFloat?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //self.dismissKeyboardWhenTappedAround()
        
        self.toolbarBottomConstraintInitialValue = toolbarBottomConstraint?.constant
        
        //self.customToolbar.removeFromSuperview()
        enableKeyboardHideOnTap()
    }
    
    private func enableKeyboardHideOnTap(){
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        // See 4.1
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        //See 4.2

           // 3.1
        dismissKeyboardWhenTappedAround()
       }

    //3.1

    //4.1
    @objc func keyboardWillShow(notification: NSNotification) {

        let info = notification.userInfo!

        let keyboardFrame: CGRect = (info[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue

        if let durationNumber = notification.userInfo![UIResponder.keyboardFrameEndUserInfoKey] as? NSNumber, let curveValue = info[UIResponder.keyboardAnimationCurveUserInfoKey] as? NSNumber {
            let duration = durationNumber.doubleValue
            let keyboardCurve = curveValue.intValue
            let curve: UIView.AnimationCurve = UIView.AnimationCurve(rawValue: keyboardCurve) ?? .linear
            let options = UIView.AnimationOptions(rawValue: UInt(curve.rawValue << 16))
            
            UIView.animate(withDuration: duration, delay: 0, options: options, animations: {
                self.view.layoutIfNeeded()
            }, completion: nil)
        }
        else {
            self.toolbarBottomConstraint?.constant = keyboardFrame.size.height - 35
            self.view.layoutIfNeeded()
        }
        

    }

    //4.2
    @objc func keyboardWillHide(notification: NSNotification) {

        let info = notification.userInfo!

        if let durationNumber = notification.userInfo![UIResponder.keyboardFrameEndUserInfoKey] as? NSNumber, let curveValue = info[UIResponder.keyboardAnimationCurveUserInfoKey] as? NSNumber {
            let duration = durationNumber.doubleValue
            let keyboardCurve = curveValue.intValue
            let curve: UIView.AnimationCurve = UIView.AnimationCurve(rawValue: keyboardCurve) ?? .linear
            let options = UIView.AnimationOptions(rawValue: UInt(curve.rawValue << 16))
            
            UIView.animate(withDuration: duration, delay: 0, options: options, animations: {
                self.toolbarBottomConstraint.constant = 8
                self.view.layoutIfNeeded()
            }, completion: nil)
        }
        else {
            self.toolbarBottomConstraint.constant = 8
            self.view.layoutIfNeeded()
        }
    }

}
