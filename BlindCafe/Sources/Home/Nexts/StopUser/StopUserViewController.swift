//
//  StopUserViewController.swift
//  BlindCafe
//
//  Created by 권하은 on 2021/11/30.
//

import UIKit

class StopUserViewController: BaseViewController {

    @IBOutlet weak var stopLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        stopLabel.text = "\(UserDefaults.standard.string(forKey: "UserNickname") ?? "")님은 5번 이상의 신고를 받아 현재 정지계정으로 전환되었습니다.\n\n계정을 활성화하려면 블라인드카페 이메일(blindcafeapp@gmail.com)로 문의주시길 바랍니다."
    }


}
