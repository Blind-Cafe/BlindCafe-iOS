//
//  SelectDrinkViewController.swift
//  BlindCafe
//
//  Created by 권하은 on 2021/11/13.
//

import UIKit

class SelectDrinkViewController: BaseViewController {

    @IBOutlet weak var drinkCollectionView: UICollectionView!
    
    var page: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        page = 0
        
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
        cell.drinkButton.setImage(UIImage(named: "americano"), for: .normal)
        return cell
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
