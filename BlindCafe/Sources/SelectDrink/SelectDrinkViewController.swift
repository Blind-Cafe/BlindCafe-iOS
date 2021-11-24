//
//  SelectDrinkViewController.swift
//  BlindCafe
//
//  Created by 권하은 on 2021/11/13.
//

import UIKit

class SelectDrinkViewController: BaseViewController {

    @IBOutlet weak var drinkCollectionView: UICollectionView!
    
    @IBOutlet weak var cafeLabel: UILabel!
    
    var start: String = ""
    
    var matchingId: Int = 0
    var partnerName = ""
    
    var page: Int = 0
    
    var drinks = ["americano", "cafelatte", "cafemocha", "bubbletea", "mintchocolate", "strawberry", "bluelemonade", "greentea", "grapefruittea"]
    
    var selected: Int? = nil
    
    @IBOutlet weak var nextButton: UIButton!
    @IBAction func nextButton(_ sender: Any) {
        showIndicator()
        let input = SelectDrinkInput(drink: selected! + 1)
        SelectDrinkDataManager().requestDrink(id: matchingId, input, viewController: self)
        
        let vc = ChattingViewController()
        vc.startTime = start
        vc.matchingId = matchingId
        vc.partnerName = partnerName
        navigationController?.pushViewController(vc, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        nextButton.isEnabled = false
        // Do any additional setup after loading the view.
        page = 0
        cafeLabel.text = "누군가 \(UserDefaults.standard.string(forKey: "UserNickname")!)님과 합석하고 싶어해요 음료수를 고르시면 테이블로 안내해드릴게요"
        let backButton: UIButton = UIButton()
        backButton.setImage(UIImage(named: "backbutton"), for: .normal)
        backButton.addTarget(self, action: #selector(popToVC), for: .touchUpInside)
        backButton.frame = CGRect(x: 18, y: 0, width: 44, height: 44)
        let addBackButton = UIBarButtonItem(customView: backButton)
        
        self.navigationItem.setLeftBarButton(addBackButton, animated: false)
        
        let titleview = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 44))
        let titleLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 100, height: 44))
        titleLabel.text = "메뉴 주문하기"
        titleLabel.font = .SpoqaSans(.bold, size: 16)
        titleLabel.textColor = .white2
        titleLabel.textAlignment = .center
        titleview.addSubview(titleLabel)
        self.navigationItem.titleView = titleview
        
        drinkCollectionView.register(UINib(nibName: "DrinkCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "DrinkCollectionViewCell")
        
        drinkCollectionView.delegate = self
        drinkCollectionView.dataSource = self
        drinkCollectionView.backgroundColor = .mainBlack
        
    }
}

extension SelectDrinkViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 9
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DrinkCollectionViewCell", for: indexPath) as! DrinkCollectionViewCell
        
        if indexPath.row == selected {
            cell.drinkImage.image = UIImage(named: "\(drinks[indexPath.row])selected")
        }
        else {
            cell.drinkImage.image = UIImage(named: drinks[indexPath.row])
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selected = indexPath.row
        nextButton.isEnabled = true
        drinkCollectionView.reloadData()
    }

    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath != [0, page] {
            return CGSize(width: 136, height: 245)
        }
        else {
            return CGSize(width: 171, height: 245)
        }
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        page = Int(scrollView.contentOffset.x / 136)
        
        drinkCollectionView.reloadData()
    }
    
    
}

extension SelectDrinkViewController {
    func selectDrink(result: SelectDrinkResponse) {
        dismissIndicator()
    }
    
    func failedToRequest(message: String) {
        dismissIndicator()
        presentAlert(message: message)
    }
}
