//
//  InterestChangeViewController.swift
//  BlindCafe
//
//  Created by 권하은 on 2021/11/22.
//

import UIKit

class InterestChangeViewController: BaseViewController {
    
    var selectedButtons: Int = 0
    var selectedList: [String] = []
    
    @IBOutlet var interestButtons: [UIButton]!
    
    @IBAction func interestAction(_ sender: UIButton) {
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
            nextButton.setImage(UIImage(named: "interestnextbuttonenabled"), for: .normal)
        }
        else {
            nextButton.setImage(UIImage(named: "interestnextbutton"), for: .normal)
        }
        print(selectedList)
    }
    
    @IBOutlet weak var nextButton: UIButton!
    @IBAction func nextButton(_ sender: Any) {
        if selectedButtons != 3 {
            self.presentBottomAlert(message: "관심사를 먼저 선택해주세요")
        }
        else if selectedButtons == 3 {
            let vc = InterestDetailChangeViewController()
            vc.selectedList = selectedList
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setNavigation()
        
        for i in 0...8 {
            interestButtons[i].tag = i + 1
        }
    }

    func setNavigation() {
        let backButton: UIButton = UIButton()
        backButton.setImage(UIImage(named: "backbutton"), for: .normal)
        backButton.addTarget(self, action: #selector(popToVC), for: .touchUpInside)
        backButton.frame = CGRect(x: 18, y: 0, width: 44, height: 44)
        let addBackButton = UIBarButtonItem(customView: backButton)
        
        self.navigationItem.setLeftBarButton(addBackButton, animated: false)
        
        let titleview = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 44))
        let titleLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 100, height: 44))
        titleLabel.text = "관심사 수정"
        titleLabel.font = .SpoqaSans(.bold, size: 16)
        titleLabel.textColor = .white2
        titleLabel.textAlignment = .center
        titleview.addSubview(titleLabel)
        self.navigationItem.titleView = titleview
    }

}
