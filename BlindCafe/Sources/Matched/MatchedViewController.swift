//
//  MatchedViewController.swift
//  BlindCafe
//
//  Created by 권하은 on 2021/10/23.
//

import UIKit

class MatchedViewController: BaseViewController {

    @IBOutlet weak var matchedTableView: UITableView!
    @IBOutlet weak var matchedView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.navigationBar.isHidden = false
        navigationController?.navigationBar.barTintColor = .mainBlack
        setNavigation()
        
        matchedTableView.register(UINib(nibName: "MatchedTableViewCell", bundle: nil), forCellReuseIdentifier: "MatchedTableViewCell")
        matchedTableView.delegate = self
        matchedTableView.dataSource = self
        
        print(Token.jwtToken)
        
        showIndicator()
        MatchingDataManager().getMatchings(viewController: self)
    }
    
    func setNavigation() {
        let titleLabel = UILabel(frame: CGRect(x: view.bounds.width / 2 - 50, y: 10, width: 100, height: 22))
        titleLabel.text = "내 테이블"
        titleLabel.font = .SpoqaSans(.bold, size: 15)
        titleLabel.textColor = .white2
        navigationController?.navigationBar.addSubview(titleLabel)
    }
}

extension MatchedViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MatchedTableViewCell", for: indexPath)
        
        return cell
    }
    
    
}

extension MatchedViewController {
    func getMatching(result: MatchingResponse) {
        dismissIndicator()
    }
    
    func failedToRequest(message: String) {
        dismissIndicator()
        presentAlert(message: message)
    }
}
