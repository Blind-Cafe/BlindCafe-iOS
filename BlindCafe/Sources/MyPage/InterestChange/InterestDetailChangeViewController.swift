//
//  InterestDetailChangeViewController.swift
//  BlindCafe
//
//  Created by 권하은 on 2021/11/29.
//

import UIKit

class InterestDetailChangeViewController: UIViewController {
    
    var interestdata: InterestResponse!
    var selectedList: [String] = []
    
    @IBOutlet weak var interest1Label: UILabel!
    @IBOutlet weak var interest2Label: UILabel!
    @IBOutlet weak var interest3Label: UILabel!
    
    @IBOutlet weak var interest1CollectionView: UICollectionView!
    @IBOutlet weak var interest2CollectionView: UICollectionView!
    @IBOutlet weak var interest3CollectionView: UICollectionView!
    
    var selected1: [Int] = []
    var selectedLabel1: [String] = []
    var selected2: [Int] = []
    var selectedLabel2: [String] = []
    var selected3: [Int] = []
    var selectedLabel3: [String] = []
    
    @IBOutlet weak var nextButton: UIButton!
    @IBAction func nextButton(_ sender: UIButton) {
        if selected1.count != 0 && selected2.count != 0 && selected3.count != 0 {
            var interest1: [String] = []
            var interest2: [String] = []
            var interest3: [String] = []
            
            for i in selected1 {
                interest1.append(interestdata.interests![0].sub[i])
            }
            
            for i in selected2 {
                interest2.append(interestdata.interests![1].sub[i])
            }
            
            for i in selected3 {
                interest3.append(interestdata.interests![2].sub[i])
            }
            
            let input = PutInterestInput(interests: [PutInterestResult(main: interestdata.interests![0].main, sub: interest1), PutInterestResult(main: interestdata.interests![1].main, sub: interest2), PutInterestResult(main: interestdata.interests![2].main, sub: interest3)])
            showIndicator()
            PutInterestDataManager().putInterest(input, viewController: self)
        }
        else {
            self.presentBottomAlert(name: "morethan1")
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        nextButton.isEnabled = false
        
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
        ChangeInterestDataManager().getInterest(id1: selectedList[0], id2: selectedList[1], id3: selectedList[2], viewController: self)
    }


}

extension InterestDetailChangeViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 9
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "InterestCollectionViewCell", for: indexPath) as! InterestCollectionViewCell
        if interestdata != nil {
            if collectionView == interest1CollectionView {
                cell.interestLabel.text = interestdata.interests![0].sub[indexPath.row % 9]
                if selected1.contains(indexPath.row) {
                    cell.interestView.backgroundColor = .mainGreen
                    cell.interestLabel.textColor = .white
                }
                else {
                    cell.interestView.backgroundColor = .grayishBrown
                    cell.interestLabel.textColor = .lightPink
                }
            }
            else if collectionView == interest2CollectionView {
                cell.interestLabel.text = interestdata.interests![1].sub[indexPath.row % 9]
                if selected2.contains(indexPath.row) {
                    cell.interestView.backgroundColor = .mainGreen
                    cell.interestLabel.textColor = .white
                }
                else {
                    cell.interestView.backgroundColor = .grayishBrown
                    cell.interestLabel.textColor = .lightPink
                }
            }
            else {
                cell.interestLabel.text = interestdata.interests![2].sub[indexPath.row % 9]
                if selected3.contains(indexPath.row) {
                    cell.interestView.backgroundColor = .mainGreen
                    cell.interestLabel.textColor = .white
                }
                else {
                    cell.interestView.backgroundColor = .grayishBrown
                    cell.interestLabel.textColor = .lightPink
                }
            }
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == interest1CollectionView {
            if selected1.contains(indexPath.row){
                selected1.removeAll(where: { $0 == indexPath.row })
            }
            else {
                selected1.append(indexPath.row)
            }
            interest1CollectionView.reloadData()
        }
        else if collectionView == interest2CollectionView {
            if selected2.contains(indexPath.row){
                selected2.removeAll(where: { $0 == indexPath.row })
            }
            else {
                selected2.append(indexPath.row)
            }
            interest2CollectionView.reloadData()
        }
        else if collectionView == interest3CollectionView {
            if selected3.contains(indexPath.row){
                selected3.removeAll(where: { $0 == indexPath.row })
            }
            else {
                selected3.append(indexPath.row)
            }
            interest3CollectionView.reloadData()
        }
        
        if selected1.count != 0 && selected2.count != 0 && selected3.count != 0 {
            nextButton.setImage(UIImage(named: "interestnextbuttonenabled"), for: .normal)
        }
        else {
            nextButton.setImage(UIImage(named: "interestnextbutton"), for: .normal)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: interest1CollectionView.frame.width / 3 - 6, height: interest1CollectionView.frame.height / 3 - 5.3)
    }
}


extension InterestDetailChangeViewController {
    func getInterest(result: InterestResponse) {
        dismissIndicator()
        self.interestdata = result
        
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
    
    func requested() {
        dismissIndicator()
        navigationController?.popToRootViewController(animated: false)
    }
    
    func mainName(i: Int) -> String {
        var nameString = ""
        switch interestdata.interests![i].main {
        case 1:
            nameString = "취업"
        case 2:
            nameString = "작품"
        case 3:
            nameString = "동물"
        case 4:
            nameString = "음식"
        case 5:
            nameString = "여행"
        case 6:
            nameString = "게임"
        case 7:
            nameString = "연예"
        case 8:
            nameString = "스포츠"
        case 9:
            nameString = "재테크"
        default:
            break
        }
        return nameString
    }
}

