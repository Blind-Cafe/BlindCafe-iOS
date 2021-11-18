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
    
    var page: Int = 0
    
    var drinks = ["americano", "cafelatte", "cafemocha", "bubbletea", "mintchocolate", "strawberry", "bluelemonade", "greentea", "grapefruittea"]
    
    var selected: Int? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        page = 0
        cafeLabel.text = "누군가 \(UserDefaults.standard.string(forKey: "UserNickname")!)님과 합석하고 싶어해요 음료수를 고르시면 테이블로 안내해드릴게요"
        let backButton: UIButton = UIButton()
        backButton.setImage(UIImage(named: "backbutton"), for: .normal)
        backButton.addTarget(self, action: #selector(popToVC), for: .touchUpInside)
        backButton.frame = CGRect(x: 18, y: 0, width: 44, height: 44)
        let addBackButton = UIBarButtonItem(customView: backButton)
        
        self.navigationItem.setLeftBarButton(addBackButton, animated: false)
        
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont.SpoqaSans(.bold, size: 16), NSAttributedString.Key.foregroundColor: UIColor.veryLightPink]
        self.title = "메뉴 주문하기"
        
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
        //drinkCollectionView.scrollToItem(at: [0, page], at: .centeredHorizontally, animated: true)
        
        drinkCollectionView.reloadData()
    }
}
