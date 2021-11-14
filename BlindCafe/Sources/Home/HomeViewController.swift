//
//  HomeViewController.swift
//  BlindCafe
//
//  Created by 권하은 on 2021/10/21.
//

import UIKit

class HomeViewController: BaseViewController {

    var status: String = ""
    var partnerName: String = ""
    
    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet weak var progressBar: ProgressBar!
    
    @IBOutlet weak var homeButton: UIButton!
    @IBAction func homeButton(_ sender: Any) {
        if status == "MATCHING" {
            
        }
        let vc = ChattingViewController()
        /*vc.modalPresentationStyle = .fullScreen
        vc.modalTransitionStyle = .crossDissolve
        
        self.present(vc, animated: true)*/
        vc.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(vc, animated: false)
    }
    
    //Timer
    var startTime: Date?
    var timer = Timer()
    deinit {
        timer.invalidate()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.isHidden = false
    
        guard let startTime = startTime else {
            setTimer(startTime: Date())
            return
        }
        setTimer(startTime: startTime)
    }
    
    
}

extension HomeViewController {
    func setTimer(startTime: Date) {
        DispatchQueue.main.async { [weak self] in
            self?.timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { (timer) in
                let elapsedTimeSeconds = Int(Date().timeIntervalSince(startTime))
                
                //시간 초과한 경우
                if elapsedTimeSeconds >= 259200 {
                    timer.invalidate()
                }
                
                self?.progressBar.progress = min(0.00000386 * CGFloat(elapsedTimeSeconds), 1)
            }
        }
    }
}

extension HomeViewController {
    func requestData(result: HomeResponse){
        self.dismissIndicator()
        
        switch result.matchingStatus {
        case "NONE":
            backgroundImage.image = UIImage(named: "nonebackground")
        case "WAIT":
            backgroundImage.image = UIImage(named: "nonebackground")
        case "FOUND":
            backgroundImage.image = UIImage(named: "matchingbackground")
        case "MATCHING":
            backgroundImage.image = UIImage(named: "matchingbackground")
        case "FAILED_LEAVE_ROOM":
            print("failedleaveroom")
        case "FAILED_REPORT":
            print("failedreport")
        case "FAILED_WONT_EXCHANGE":
            print("failedwontexchange")
        default:
            break
        }
    }
    
    func failedToRequest(message: String) {
        dismissIndicator()
        presentAlert(message: message)
    }
}

