//
//  HomeViewController.swift
//  BlindCafe
//
//  Created by 권하은 on 2021/10/21.
//

import UIKit
import FirebaseFirestore

class HomeViewController: BaseViewController {
    @IBOutlet weak var alarmView: UIView!
    @IBOutlet weak var alarmLabel: UILabel!
    
    @IBOutlet weak var statusLabel1: UILabel!
    @IBOutlet weak var statusLabel2: UILabel!
    
    var status: String = ""
    var matchingId: Int = 0
    var partnerName: String = ""
    var start: String = ""
    var reason: String = ""
    
    var newMessages: [String] = []
    
    var date: Date!
    
    var isButton = false
    
    let db = Firestore.firestore()
    
    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet weak var progressBar: ProgressBar!
    @IBOutlet weak var timeLabel: UILabel!
    
    @IBOutlet weak var homeButton: UIButton!
    @IBAction func homeButton(_ sender: Any) {
        isButton = true
        
        showIndicator()
        HomeDataManager().requestHome(viewController: self)
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
        
        alarmView.isHidden = true
        navigationController?.navigationBar.isHidden = false
        navigationController?.navigationBar.barTintColor = .mainBlack
        
        let bellButton: UIButton = UIButton()
        bellButton.setImage(UIImage(named: "homebell"), for: .normal)
        bellButton.addTarget(self, action: #selector(self.bellButtonAction), for: .touchUpInside)
        let addButton = UIBarButtonItem(customView: bellButton)
        self.navigationItem.rightBarButtonItem = addButton
        alarmLabel.text = "0건의 메세지가 도착했습니다."
        
        view.backgroundColor = .mainBlack
        let titleImage = UIImageView(image: UIImage(named: "blindcafe"))
        titleImage.center = (navigationController?.navigationBar.center)!
        navigationController?.navigationBar.topItem?.titleView = titleImage
        
        dismissWhenTappedAround()
        
        print(Token.jwtToken)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        showIndicator()
        HomeDataManager().requestHome(viewController: self)
        loadMessages()
    }
    
    @objc func bellButtonAction(_ sender: UIButton) {
        if alarmView.isHidden {
            alarmView.isHidden = false
        } else {
            alarmView.isHidden = true
        }
    }
    
    func refresh() {
        DispatchQueue.main.async { [weak self] in
            self!.timer1 = Timer.scheduledTimer(withTimeInterval: 5, repeats: true) { (timer) in
                HomeDataManager().requestHome(viewController: self!)
            }
        }
    }
    
    func dismissWhenTappedAround() {
        let tap: UITapGestureRecognizer =
            UITapGestureRecognizer(target: self, action: #selector(self.dismissAll))
        self.view.addGestureRecognizer(tap)
    }
    
    @objc func dismissAll() {
        self.alarmView.isHidden = true
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
                
                let elapsedTimeSecond = Int(Date().timeIntervalSince(self?.date ?? Date()))
                let hours = elapsedTimeSecond / 3600
                let minutes = (elapsedTimeSecond % 3600) / 60
                self?.timeLabel.text = String(format: "%02d : %02d", hours, minutes)
            }
        }
    }
    
    func loadMessages() {
        db.collection("Rooms/\(matchingId)/Messages")
            .order(by: "timestamp")
            .addSnapshotListener { (querySnapshot, error) in
                self.newMessages = []
                
                if let e = error {
                    print(e.localizedDescription)
                } else {
                    if let snapshotDocuments = querySnapshot?.documents {
                        snapshotDocuments.forEach { (doc) in
                            let data = doc.data()
                            if let id = data["id"] as? String {
                                self.newMessages.append(id)
                                if self.newMessages.count > UserDefaults.standard.integer(forKey: "LastIndex") {
                                    self.alarmLabel.text = "\(self.newMessages.count - UserDefaults.standard.integer(forKey: "LastIndex"))건의 메세지가 도착했습니다."
                                    let bellButton: UIButton = UIButton()
                                    bellButton.setImage(UIImage(named: "homebellselected"), for: .normal)
                                    bellButton.addTarget(self, action: #selector(self.bellButtonAction), for: .touchUpInside)
                                    let addButton = UIBarButtonItem(customView: bellButton)
                                    self.navigationItem.rightBarButtonItem = addButton
                                } else {
                                    self.alarmLabel.text = "0건의 메세지가 도착했습니다."
                                    let bellButton: UIButton = UIButton()
                                    bellButton.setImage(UIImage(named: "homebell"), for: .normal)
                                    bellButton.addTarget(self, action: #selector(self.bellButtonAction), for: .touchUpInside)
                                    let addButton = UIBarButtonItem(customView: bellButton)
                                    self.navigationItem.rightBarButtonItem = addButton
                                }
                            }
                        }
                    }
                }
            }
        

    }
}

extension HomeViewController {
    func requestData(result: HomeResponse){
        self.dismissIndicator()
        
        //print(result.matchingId)
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
            statusLabel1.isHidden = false
            statusLabel2.isHidden = false
            statusLabel1.text = "매칭하기"
            statusLabel2.text = "\n하트를 눌러 매칭을 시작하세요"
            UserDefaults.standard.set(0,forKey: "LastIndex")
        case "WAIT":
            backgroundImage.image = UIImage(named: "nonebackground")
            homeButton.setImage(UIImage(named: "waithomebutton"), for: .normal)
            progressBar.isHidden = true
            timeLabel.isHidden = true
            statusLabel1.isHidden = true
            statusLabel2.isHidden = false
            statusLabel2.text = "대화 상대방을 찾고 있습니다.\n잠시만 기다려주세요."
        case "FOUND":
            backgroundImage.image = UIImage(named: "matchingbackground")
            progressBar.isHidden = false
            progressBar.removeForegroundLayer()
            homeButton.setImage(UIImage(named: "matchinghomebutton"), for: .normal)
            timeLabel.isHidden = false
            timeLabel.text = "00:00"
            statusLabel1.isHidden = false
            statusLabel2.isHidden = false
            statusLabel1.text = "대화하기"
            statusLabel2.text = "\n하트를 눌러 상대방과 대화를 시작하세요"
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
            timeLabel.isHidden = false
            timeLabel.text = String(format: "%02d : %02d", hours, minutes)
            
            loadMessages()
            
            statusLabel1.isHidden = false
            statusLabel2.isHidden = false
            statusLabel1.text = "대화하기"
            statusLabel2.text = "\n하트를 눌러 상대방과 대화를 시작하세요"
        case "FAILED_LEAVE_ROOM":
            reason = result.reason ?? ""
            let str = "\(partnerName)님이 \"\(reason)\"라는 이유로 대화를 진행하지 못하게 되었습니다.\n\n아쉽지만 새로운 손님과 또 다른 추억을 쌓을 수 있습니다."
            let attributedstr = NSMutableAttributedString(string: str)
            attributedstr.addAttribute(.foregroundColor, value: UIColor(hex: 0xb1d0b7), range: (str as NSString).range(of: reason))
            let vc = Leave2ViewController()
            vc.reasonattr = attributedstr
            vc.modalPresentationStyle = .fullScreen
            vc.modalTransitionStyle = .crossDissolve
            present(vc, animated: false, completion: nil)
            
            statusLabel1.isHidden = false
            statusLabel2.isHidden = false
            statusLabel1.text = "대화하기"
            statusLabel2.text = "\n하트를 눌러 상대방과 대화를 시작하세요"
        case "FAILED_REPORT":
            reason = result.reason ?? ""
            let str = "\(partnerName)님이 불편함을 느껴 대화를 종료했습니다.\n\n아쉽지만 새로운 손님과 또 다른 추억을 쌓으러 가볼까요?"
            let vc = Leave2ViewController()
            vc.reason = str
            vc.modalPresentationStyle = .fullScreen
            vc.modalTransitionStyle = .crossDissolve
            present(vc, animated: false, completion: nil)
            
            statusLabel1.isHidden = false
            statusLabel2.isHidden = false
            statusLabel1.text = "대화하기"
            statusLabel2.text = "\n하트를 눌러 상대방과 대화를 시작하세요"
        case "FAILED_WONT_EXCHANGE":
            reason = result.reason ?? ""
            let str = "\(partnerName)님이 \"\(reason)\"라는 이유로 대화를 진행하지 못하게 되었습니다.\n\n아쉽지만 새로운 손님과 또 다른 추억을 쌓을 수 있습니다."
            let attributedstr = NSMutableAttributedString(string: str)
            attributedstr.addAttribute(.foregroundColor, value: UIColor(hex: 0xb1d0b7), range: (str as NSString).range(of: reason))
            let vc = Leave2ViewController()
            vc.reasonattr = attributedstr
            vc.modalPresentationStyle = .fullScreen
            vc.modalTransitionStyle = .crossDissolve
            present(vc, animated: false, completion: nil)
            
            statusLabel1.isHidden = false
            statusLabel2.isHidden = false
            statusLabel1.text = "대화하기"
            statusLabel2.text = "\n하트를 눌러 상대방과 대화를 시작하세요"
        case "PPROFILE_OPEN", "PROFILE_READY", "PROFILE_ACCEPT", "MATCHING_CONTINUE":
            timeLabel.text = "72:00"
        default:
            break
        }
        
        if isButton {
            isButton = false
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
            case "PROFILE_ACCEPT":
                showIndicator()
                ProfileAcceptDataManager().profileAccept(id: matchingId, viewController: self)
            case "MATCHING_CONTINUE":
                let vc = ProfileAcceptedViewController()
                vc.hidesBottomBarWhenPushed = true
                navigationController?.pushViewController(vc, animated: true)
            default:
                break
            }
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
            timeLabel.text = "00:00"
        default:
            break
        }
    }
    
    func profileReady(result: GetPartnerProfileResponse){
        dismissIndicator()
        if result.fill == false {
            let vc = WaitProfileViewController()
            vc.partnerName = result.nickname
            vc.hidesBottomBarWhenPushed = true
            navigationController?.pushViewController(vc, animated: true)
        } else {
            let vc = ProfileAcceptViewController()
            vc.hidesBottomBarWhenPushed = true
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func profileAccepted(result: GetMatchingResponse) {
        dismissIndicator()
        if result.continuous != true {
            let vc = WaitProfileViewController()
            vc.partnerName = partnerName
            vc.hidesBottomBarWhenPushed = true
            navigationController?.pushViewController(vc, animated: true)
        }
        else {
            let vc = ProfileAcceptedViewController()
            vc.modalPresentationStyle = .fullScreen
            vc.modalTransitionStyle = .crossDissolve
            present(vc, animated: true, completion: nil)
        }
        
    }
    
    func stopUser(){
        dismissIndicator()
        let vc = StopUserViewController()
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true, completion: nil)
    }
    
    func failedToRequest(message: String) {
        dismissIndicator()
        presentAlert(message: message)
    }
}

