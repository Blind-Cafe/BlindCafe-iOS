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
    @IBOutlet weak var navigationView: UIView!
    
    var matchedData: MatchingResponse?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.isHidden = false
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.barTintColor = .brownGray
        navigationView.backgroundColor = .mainBlack
        setNavigation()
        
        matchedTableView.register(UINib(nibName: "MatchedTableViewCell", bundle: nil), forCellReuseIdentifier: "MatchedTableViewCell")
        matchedTableView.delegate = self
        matchedTableView.dataSource = self
        matchedTableView.backgroundColor = .brownGray
        
        print(Token.jwtToken)
        
        showIndicator()
        MatchingDataManager().getMatchings(viewController: self)
    }
    
    func setNavigation() {
        let titleview = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 44))
        let titleLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 100, height: 44))
        titleLabel.text = "내 테이블"
        titleLabel.font = .SpoqaSans(.bold, size: 16)
        titleLabel.textColor = .white2
        titleLabel.textAlignment = .center
        titleview.addSubview(titleLabel)
        self.navigationItem.titleView = titleview
    }
}

extension MatchedViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return matchedData?.matchings?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MatchedTableViewCell", for: indexPath) as! MatchedTableViewCell
        if matchedData != nil && matchedData?.matchings?.count != 0 {
            cell.partnerName.text = matchedData!.matchings![indexPath.row].partner.nickname
        }
        
        return cell
    }
    
}

extension MatchedViewController {
    func getMatching(result: MatchingResponse) {
        dismissIndicator()
        matchedData = result
        
        if matchedData?.matchings?.count == 0 {
            matchedView.isHidden = false
            navigationView.backgroundColor = .mainBlack
            navigationController?.navigationBar.barTintColor = .mainBlack
        }
        else {
            matchedView.isHidden = true
            navigationView.backgroundColor = .brownGray
            navigationController?.navigationBar.barTintColor = .brownGray
        }
        
        matchedTableView.reloadData()
    }
    
    func failedToRequest(message: String) {
        dismissIndicator()
        presentAlert(message: message)
    }
}
