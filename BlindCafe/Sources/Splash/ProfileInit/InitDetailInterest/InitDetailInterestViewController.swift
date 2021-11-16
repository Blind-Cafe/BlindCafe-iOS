//
//  InitDetailInterestViewController.swift
//  BlindCafe
//
//  Created by 권하은 on 2021/11/13.
//

import UIKit

class InitDetailInterestViewController: BaseOnboardingViewController {
    
    var interestdata: InterestResponse!
    var selectedList: [String] = []
    
    @IBOutlet weak var interest1Label: UILabel!
    @IBOutlet weak var interest2Label: UILabel!
    @IBOutlet weak var interest3Label: UILabel!
    
    @IBOutlet weak var interest1CollectionView: UICollectionView!
    @IBOutlet weak var interest2CollectionView: UICollectionView!
    @IBOutlet weak var interest3CollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //scrollView.contentInsetAdjustmentBehavior = .never
        setBackButton()
        
        interest1CollectionView.delegate = self
        interest1CollectionView.dataSource = self
        interest1CollectionView.register(UINib(nibName: "InterestCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "InterestCollectionViewCell")
        interest2CollectionView.delegate = self
        interest2CollectionView.dataSource = self
        interest2CollectionView.register(UINib(nibName: "InterestCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "InterestCollectionViewCell")
        interest3CollectionView.delegate = self
        interest3CollectionView.dataSource = self
        interest3CollectionView.register(UINib(nibName: "InterestCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "InterestCollectionViewCell")
        
        interest1CollectionView.backgroundColor = .black2
        interest2CollectionView.backgroundColor = .black2
        interest3CollectionView.backgroundColor = .black2
        
        showIndicator()
        InterestDataManager().getInterest(id1: selectedList[0], id2: selectedList[1], id3: selectedList[2], viewController: self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    

}

extension InitDetailInterestViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 9
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "InterestCollectionViewCell", for: indexPath) as! InterestCollectionViewCell
        if interestdata != nil {
            if collectionView == interest1CollectionView {
                cell.interestLabel.text = interestdata.interests![0].sub[indexPath.row % 9]
            }
            else if collectionView == interest2CollectionView {
                cell.interestLabel.text = interestdata.interests![1].sub[indexPath.row % 9]
            }
            else {
                cell.interestLabel.text = interestdata.interests![2].sub[indexPath.row % 9]
            }
        }
        
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: interest1CollectionView.frame.width / 3 - 6, height: interest1CollectionView.frame.height / 3 - 5.3)
    }
}


extension InitDetailInterestViewController {
    func getInterest(result: InterestResponse) {
        dismissIndicator()
        self.interestdata = result
        print(interestdata)
        
        interest1Label.text = mainName(i: 0)
        interest2Label.text = mainName(i: 1)
        interest3Label.text = mainName(i: 2)
        
        interest1CollectionView.reloadData()
        interest2CollectionView.reloadData()
        interest3CollectionView.reloadData()
    }
    
    func failedToRequest(message: String) {
        dismissIndicator()
        presentAlert(message: message)
    }
    
    func mainName(i: Int) -> String {
        var nameString = ""
        switch interestdata.interests![i].main {
        case 1:
            nameString = "음식"
        case 2:
            nameString = "여행"
        case 3:
            nameString = "게임"
        case 4:
            nameString = "연예"
        case 5:
            nameString = "스포츠"
        case 6:
            nameString = "재테크"
        case 7:
            nameString = "취업"
        case 8:
            nameString = "만화/애니"
        case 9:
            nameString = "동물"
        default:
            break
        }
        return nameString
    }
}
