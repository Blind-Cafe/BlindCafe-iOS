//
//  InitDetailInterestViewController.swift
//  BlindCafe
//
//  Created by 권하은 on 2021/11/13.
//

import UIKit

class InitDetailInterestViewController: BaseOnboardingViewController {
    
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
    }

}

extension InitDetailInterestViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 9
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "InterestCollectionViewCell", for: indexPath) as! InterestCollectionViewCell
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: interest1CollectionView.frame.width / 3 - 6, height: interest1CollectionView.frame.height / 3 - 5.3)
    }
    
}

extension InitDetailInterestViewController {
    func getInterest(result: InterestResponse) {
        dismissIndicator()
    }
    
    func failedToRequest(message: String) {
        dismissIndicator()
        presentAlert(message: message)
    }
}
