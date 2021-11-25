//
//  ReportListViewController.swift
//  BlindCafe
//
//  Created by 권하은 on 2021/11/25.
//

import UIKit

class ReportListViewController: BaseViewController {

    @IBOutlet weak var reportTableView: UITableView!
    
    var reports: ReportListResponse?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let backButton: UIButton = UIButton()
        backButton.setImage(UIImage(named: "backbutton"), for: .normal)
        backButton.addTarget(self, action: #selector(popToVC), for: .touchUpInside)
        backButton.frame = CGRect(x: 18, y: 0, width: 44, height: 44)
        let addBackButton = UIBarButtonItem(customView: backButton)
        
        self.navigationItem.setLeftBarButton(addBackButton, animated: false)
        
        let titleview = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 44))
        let titleLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 100, height: 44))
        titleLabel.text = "신고내역"
        titleLabel.font = .SpoqaSans(.bold, size: 16)
        titleLabel.textColor = .white2
        titleLabel.textAlignment = .center
        titleview.addSubview(titleLabel)
        self.navigationItem.titleView = titleview

        reportTableView.register(UINib(nibName: "ReportTableViewCell", bundle: nil), forCellReuseIdentifier: "ReportTableViewCell")
        reportTableView.delegate = self
        reportTableView.dataSource = self
        reportTableView.backgroundColor = .mainBlack
        
        showIndicator()
        ReportListDataManager().getReportList(viewController: self)
    }


}

extension ReportListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return reports?.reports.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReportTableViewCell", for: indexPath) as! ReportTableViewCell
        
        if reports != nil {
            let time = reports?.reports[indexPath.row].date
            cell.TimeLabel.text = time
            cell.reportLabel1.text = "\(reports!.reports[indexPath.row].target)님을 신고함"
            cell.reportLabel2.text = reports?.reports[indexPath.row].reason
        }
        
        return cell
    }
    
    
}

extension ReportListViewController {
    func getReport(result: ReportListResponse) {
        dismissIndicator()
        reports = result
        reportTableView.reloadData()
    }
    
    func failedToRequest(message: String) {
        dismissIndicator()
        presentAlert(message: message)
    }
}
