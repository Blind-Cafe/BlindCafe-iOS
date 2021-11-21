//
//  HomeViewController.swift
//  BlindCafe
//
//  Created by 권하은 on 2021/10/21.
//

import UIKit

class HomeViewController: BaseViewController {

    var status: String = ""
    var matchingId: Int = 0
    var partnerName: String = ""
    
    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet weak var progressBar: ProgressBar!
    @IBOutlet weak var timeLabel: UILabel!
    
    @IBOutlet weak var homeButton: UIButton!
    @IBAction func homeButton(_ sender: Any) {
        switch status {
        case "NONE":
            showIndicator()
            let input = RequestMatchingInput()
            RequestMatchingDataManager().requestMatching(input, viewController: self)
        case "WAIT":
            print("waitbutton")
        case "FOUND":
            let vc = SelectDrinkViewController()
            vc.matchingId = matchingId
            vc.partnerName = partnerName
            vc.hidesBottomBarWhenPushed = true
            navigationController?.pushViewController(vc, animated: false)
        case "MATCHING":
            let vc = ChattingViewController()
            vc.matchingId = matchingId
            vc.partnerName = partnerName
            vc.hidesBottomBarWhenPushed = true
            navigationController?.pushViewController(vc, animated: false)
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
    
    //Timer
    var startTime: Date?
    var timer = Timer()
    deinit {
        timer.invalidate()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.isHidden = false
        navigationController?.navigationBar.barTintColor = .mainBlack
        
        view.backgroundColor = .mainBlack
        let titleImage = UIImageView(image: UIImage(named: "blindcafe"))
        titleImage.center = (navigationController?.navigationBar.center)!
        //navigationController?.navigationBar.addSubview(titleImage)
        navigationController?.navigationBar.topItem?.titleView = titleImage
        
        print(Token.jwtToken)
    
        showIndicator()
        HomeDataManager().requestHome(viewController: self)
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
        
        status = result.matchingStatus ?? ""
        matchingId = result.matchingId ?? -1
        UserDefaults.standard.set(matchingId, forKey: "MatchingId")
        partnerName = result.partnerNickname ?? ""
        
        switch result.matchingStatus {
        case "NONE":
            backgroundImage.image = UIImage(named: "nonebackground")
            progressBar.isHidden = true
            homeButton.isHidden = false
            homeButton.setImage(UIImage(named: "homebutton"), for: .normal)
            timeLabel.isHidden = true
        case "WAIT":
            backgroundImage.image = UIImage(named: "nonebackground")
            homeButton.setImage(UIImage(named: "waithomebutton"), for: .normal)
            progressBar.isHidden = true
            timeLabel.isHidden = true
        case "FOUND":
            backgroundImage.image = UIImage(named: "matchingbackground")
            progressBar.isHidden = false
            progressBar.removeForegroundLayer()
            homeButton.setImage(UIImage(named: "matchinghomebutton"), for: .normal)
            timeLabel.isHidden = false
            timeLabel.text = "72:00"
        case "MATCHING":
            backgroundImage.image = UIImage(named: "matchingbackground")
            progressBar.isHidden = false
            progressBar.addForegroundLayer()
            homeButton.setImage(UIImage(named: "matchinghomebutton"), for: .normal)
            let date: Date! = Date(timeIntervalSince1970: TimeInterval(Int(result.startTime!)!) / 1000)
            setTimer(startTime: date)
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
    
    func requestMatchingHome(result: RequestMatchingResponse) {
        dismissIndicator()
        status = result.matchingStatus
        matchingId = result.matchingId ?? -1
        UserDefaults.standard.set(matchingId, forKey: "MatchingId")
        partnerName = result.partnerNickname ?? ""
        
        switch status {
        case "NONE":
            backgroundImage.image = UIImage(named: "nonebackground")
            progressBar.isHidden = true
            homeButton.isHidden = false
            homeButton.setImage(UIImage(named: "homebutton"), for: .normal)
            timeLabel.isHidden = true
        case "WAIT":
            backgroundImage.image = UIImage(named: "nonebackground")
            progressBar.isHidden = true
            timeLabel.isHidden = true
        case "FOUND":
            backgroundImage.image = UIImage(named: "matchingbackground")
            progressBar.isHidden = false
            progressBar.removeForegroundLayer()
            homeButton.setImage(UIImage(named: "matchinghomebutton"), for: .normal)
            timeLabel.isHidden = false
            timeLabel.text = "72:00"
        default:
            break
        }
    }
    
    func failedToRequest(message: String) {
        dismissIndicator()
        presentAlert(message: message)
    }
}

