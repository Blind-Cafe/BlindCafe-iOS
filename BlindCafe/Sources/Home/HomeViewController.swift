//
//  HomeViewController.swift
//  BlindCafe
//
//  Created by 권하은 on 2021/10/21.
//

import UIKit

class HomeViewController: BaseViewController {

    @IBOutlet weak var progressBar: ProgressBar!
    
    @IBAction func toChatting(_ sender: Any) {
        let vc = ChattingViewController()
        vc.modalPresentationStyle = .fullScreen
        vc.modalTransitionStyle = .crossDissolve
        
        self.present(vc, animated: true)
    }
    
    //Timer
    var startTime: Date?
    var timer = Timer()
    deinit {
        timer.invalidate()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
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

