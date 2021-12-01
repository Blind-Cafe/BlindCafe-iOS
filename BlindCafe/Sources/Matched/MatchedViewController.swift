//
//  MatchedViewController.swift
//  BlindCafe
//
//  Created by 권하은 on 2021/10/23.
//

import UIKit

protocol MyTable {
    func getTable()
}

class MatchedViewController: BaseViewController, MyTable {

    func getTable() {
        showIndicator()
        MatchingDataManager().getMatchings(viewController: self)
    }
    
    var indexrow: Int = 0
    
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
        matchedTableView.separatorStyle = .none
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
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
        if matchedData?.matchings?.count != 0 {
            cell.partnerName.text = matchedData!.matchings![indexPath.row].partner.nickname
            cell.timeLeft.text = matchedData!.matchings![indexPath.row].expiryTime
            cell.lastMessage.text = matchedData!.matchings![indexPath.row].latestMessage
            
            if matchedData!.matchings![indexPath.row].partner.profileImage != nil {
                let url = URL(string: matchedData!.matchings![indexPath.row].partner.profileImage!)
                let data = try? Data(contentsOf: url!)
                cell.partnerProfile.image = UIImage(data: data!)
            }
            
            if matchedData!.matchings![indexPath.row].received {
                cell.lastMessageImage.isHidden = true
            } else {
                cell.lastMessageImage.isHidden = false
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        indexrow = indexPath.row
        
        showIndicator()
        GetMatchedRoomDataManager().getRoom(id: matchedData?.matchings![indexrow].matchingId ?? 0, viewController: self)
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
    
    func getroom(result: GetMatchingResponse) {
        dismissIndicator()
        let vc = MatchedChattingViewController()
        vc.matchingId =  matchedData?.matchings![indexrow].matchingId ?? 0
        vc.partnerName = (matchedData?.matchings![indexrow].partner.nickname)!
        vc.matchingId = (matchedData?.matchings![indexrow].matchingId)!
        vc.startTime = result.startTime
        
        vc.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(vc, animated: false)
    }
    
    func failedToRequest(message: String) {
        dismissIndicator()
        presentAlert(message: message)
    }
}

