//
//  SettingsViewController.swift
//  BlindCafe
//
//  Created by 권하은 on 2021/11/20.
//

import UIKit

class SettingsViewController: BaseViewController {

    @IBOutlet weak var settingButton1: UIButton!
    @IBAction func settingButton1(_ sender: UIButton) {
        if sender.isSelected {
            sender.isSelected = false
        }
        else {
            sender.isSelected = true
        }
    }
    
    @IBOutlet weak var settingbutton2: UIButton!
    @IBAction func settingButton2(_ sender: UIButton) {
        if sender.isSelected {
            sender.isSelected = false
        }
        else {
            sender.isSelected = true
        }
    }
    
    @IBOutlet weak var settingButton3: UIButton!
    @IBAction func settingButton3(_ sender: UIButton) {
        if sender.isSelected {
            sender.isSelected = false
        }
        else {
            sender.isSelected = true
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let backButton: UIButton = UIButton()
        backButton.setImage(UIImage(named: "backbutton"), for: .normal)
        backButton.addTarget(self, action: #selector(popToVC), for: .touchUpInside)
        backButton.frame = CGRect(x: 18, y: 0, width: 44, height: 44)
        let addBackButton = UIBarButtonItem(customView: backButton)
        
        self.navigationItem.setLeftBarButton(addBackButton, animated: false)
        
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont.SpoqaSans(.bold, size: 16), NSAttributedString.Key.foregroundColor: UIColor.veryLightPink]
        self.title = "설정"
    }

}
