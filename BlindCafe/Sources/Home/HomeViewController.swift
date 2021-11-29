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
    var start: String = ""
    var reason: String = ""
    
    var date: Date!
    
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
            let vc = MatchingCancelViewController()
            vc.modalPresentationStyle = .overCurrentContext
            vc.modalTransitionStyle = .crossDissolve
            present(vc, animated: false)
        case "FOUND":
            let vc = SelectDrinkViewController()
            vc.matchingId = matchingId
            vc.partnerName = partnerName
            vc.start = start
            vc.hidesBottomBarWhenPushed = true
            navigationController?.pushViewController(vc, animated: false)
        case "MATCHING":
            let vc = ChattingViewController()
            vc.matchingId = matchingId
            vc.partnerName = partnerName
            vc.startTime = start
            vc.hidesBottomBarWhenPushed = true
            navigationController?.pushViewController(vc, animated: false)
        case "PROFILE_OPEN":
            let vc = ProfileOpenViewController()
            vc.hidesBottomBarWhenPushed = true
            navigationController?.pushViewController(vc, animated: false)
        case "PROFILE_READY":
            showIndicator()
            ProfileReadyDataManager().getPartnerProfile(id: UserDefaults.standard.integer(forKey: "MatchingId"), viewController: self)
            
        case "FAILED_LEAVE_ROOM":
            let str = "\(partnerName)님이 \"\(reason)\"라는 이유로 대화를 진행하지 못하게 되었습니다.\n\n아쉽지만 새로운 손님과 또 다른 추억을 쌓을 수 있습니다."
            let attributedstr = NSMutableAttributedString(string: str)
            attributedstr.addAttribute(.foregroundColor, value: UIColor(hex: 0xb1d0b7), range: (str as NSString).range(of: reason))
            let vc = Leave2ViewController()
            vc.reasonattr = attributedstr
            navigationController?.pushViewController(vc, animated: true)
        case "FAILED_REPORT":
            let str = "\(partnerName)님이 불편함을 느껴 대화를 종료했습니다.\n\n아쉽지만 새로운 손님과 또 다른 추억을 쌓으러 가볼까요?"
            let vc = Leave2ViewController()
            vc.reason = str
            navigationController?.pushViewController(vc, animated: true)
        case "FAILED_WONT_EXCHANGE":
            let str = "\(partnerName)님이 \"\(reason)\"라는 이유로 대화를 진행하지 못하게 되었습니다.\n\n아쉽지만 새로운 손님과 또 다른 추억을 쌓을 수 있습니다."
            let attributedstr = NSMutableAttributedString(string: str)
            attributedstr.addAttribute(.foregroundColor, value: UIColor(hex: 0xb1d0b7), range: (str as NSString).range(of: reason))
            let vc = Leave2ViewController()
            vc.reasonattr = attributedstr
            navigationController?.pushViewController(vc, animated: true)
        default:
            break
        }
        
    }
    
    //Timer
    var startTime: Date?
    var timer = Timer()
    deinit {
        timer.invalidate()
        timer1.invalidate()
    }
    
    var timer1 = Timer()
    
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
       
        refresh()
    }
    
    func refresh() {
        DispatchQueue.main.async { [weak self] in
            self!.timer1 = Timer.scheduledTimer(withTimeInterval: 5, repeats: true) { (timer) in
                HomeDataManager().requestHome(viewController: self!)
            }
        }
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
                
                let elapsedTimeSecond = Int(Date().timeIntervalSince(self!.date))
                let hours = elapsedTimeSecond / 3600
                let minutes = (elapsedTimeSecond % 3600) / 60
                self!.timeLabel.text = String(format: "%02d : %02d", hours, minutes)
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
        start = result.startTime ?? ""
        
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
            date = Date(timeIntervalSince1970: TimeInterval(Int(result.startTime!)!).rounded())
            setTimer(startTime: date)
            
            let elapsedTimeSeconds = Int(Date().timeIntervalSince(date))
            let hours = elapsedTimeSeconds / 3600
            let minutes = (elapsedTimeSeconds % 3600) / 60
            timeLabel.text = String(format: "%02d : %02d", hours, minutes)
        case "FAILED_LEAVE_ROOM":
            reason = result.reason ?? ""
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
    
    func profileReady(result: GetPartnerProfileResponse){
        dismissIndicator()
        if result.fill == false {
            let vc = WaitProfileViewController()
            vc.partnerName = result.nickname
            navigationController?.pushViewController(vc, animated: true)
        } else {
            let vc = ProfileAcceptViewController()
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func failedToRequest(message: String) {
        dismissIndicator()
        presentAlert(message: message)
    }
}

