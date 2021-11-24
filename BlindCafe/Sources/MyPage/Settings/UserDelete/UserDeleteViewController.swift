//
//  UserDeleteViewController.swift
//  BlindCafe
//
//  Created by 권하은 on 2021/11/24.
//

import UIKit

class UserDeleteViewController: BaseViewController {

    @IBOutlet var reasonButtons: [UIButton]!
    var indexOfOneAndOnly: Int?
    @IBAction func reasonButtons(_ sender: UIButton) {
        if indexOfOneAndOnly != nil {
            if !sender.isSelected {
                for index in reasonButtons.indices {
                    reasonButtons[index].isSelected = false
                }
                sender.isSelected = true
                indexOfOneAndOnly = reasonButtons.firstIndex(of: sender)
                nextButton.isEnabled = true
            }
            else {
                sender.isSelected = false
                indexOfOneAndOnly = nil
                nextButton.isEnabled = false
            }
        }
        else {
            sender.isSelected = true
            indexOfOneAndOnly = reasonButtons.firstIndex(of: sender)
            nextButton.isEnabled = true
        }
    }
    
    @IBOutlet weak var nextButton: UIButton!
    @IBAction func nextButton(_ sender: Any) {
        let childVC2 = UserDelete2ViewController()
        childVC2.modalPresentationStyle = .overCurrentContext
        present(childVC2, animated: false, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        nextButton.isEnabled = false
        
        let backButton: UIButton = UIButton()
        backButton.setImage(UIImage(named: "backbutton"), for: .normal)
        backButton.addTarget(self, action: #selector(popToVC), for: .touchUpInside)
        backButton.frame = CGRect(x: 18, y: 0, width: 44, height: 44)
        let addBackButton = UIBarButtonItem(customView: backButton)
        
        self.navigationItem.setLeftBarButton(addBackButton, animated: false)
        
        let titleview = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 44))
        let titleLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 100, height: 44))
        titleLabel.text = "계정삭제"
        titleLabel.font = .SpoqaSans(.bold, size: 16)
        titleLabel.textColor = .white2
        titleLabel.textAlignment = .center
        titleview.addSubview(titleLabel)
        self.navigationItem.titleView = titleview
    }



}
