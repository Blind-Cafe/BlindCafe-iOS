//
//  DetailProfileViewController.swift
//  BlindCafe
//
//  Created by 권하은 on 2021/12/30.
//

import UIKit

class DetailProfileViewController: UIViewController {

    @IBOutlet weak var profileImageCollectionView: UICollectionView!
    @IBOutlet weak var nicknameLabel: UILabel!
    @IBOutlet weak var ageLabel: UILabel!
    @IBOutlet weak var regionLabel: UILabel!
    
    @IBOutlet var interestLabels: [UILabel]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        for i in interestLabels {
            i.cornerRadius = i.frame.height / 2
        }
    }
}
