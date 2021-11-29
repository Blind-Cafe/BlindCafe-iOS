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
    
    @IBAction func toLogout(_ sender: Any) {
        let vc = LogoutViewController()
        vc.modalPresentationStyle = .overCurrentContext
        vc.modalTransitionStyle = .crossDissolve
        
        present(vc, animated: false)
    }
    
    @IBAction func reportListButton(_ sender: Any) {
        navigationController?.pushViewController(ReportListViewController(), animated: true)
    }
    
    @IBAction func deleteButton(_ sender: Any) {
        navigationController?.pushViewController(UserDeleteViewController(), animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let backButton: UIButton = UIButton()
        backButton.setImage(UIImage(named: "backbutton"), for: .normal)
        backButton.addTarget(self, action: #selector(popToVC), for: .touchUpInside)
        backButton.frame = CGRect(x: 18, y: 0, width: 44, height: 44)
        let addBackButton = UIBarButtonItem(customView: backButton)
        
        self.navigationItem.setLeftBarButton(addBackButton, animated: false)
        
        let titleview = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 44))
        let titleLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 100, height: 44))
        titleLabel.text = "설정"
        titleLabel.font = .SpoqaSans(.bold, size: 16)
        titleLabel.textColor = .white2
        titleLabel.textAlignment = .center
        titleview.addSubview(titleLabel)
        self.navigationItem.titleView = titleview
    }

}
