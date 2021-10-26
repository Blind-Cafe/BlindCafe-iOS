//
//  OnboardingViewController.swift
//  BlindCafe
//
//  Created by 권하은 on 2021/10/25.
//

import UIKit

class OnboardingViewController: UIViewController {

    @IBOutlet weak var onboardingCollectionView: UICollectionView!
    
    @IBOutlet weak var pageControl: UIPageControl!
    var nowPage: Int = 0
    
    @IBAction func skipButton(_ sender: Any) {
        changeRootViewController(LoginViewController())
    }
    
    @IBAction func nextButton(_ sender: Any) {
        if nowPage == 3 {
            changeRootViewController(LoginViewController())
        }
        else {
            nowPage += 1
            self.pageControl.currentPage = nowPage
            onboardingCollectionView.scrollToItem(at: IndexPath(item: nowPage, section: 0), at: .right, animated: true)
        }
    }
    
    var images = ["onboarding1", "onboarding2", "onboarding3", "onboarding4"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        onboardingCollectionView.delegate = self
        onboardingCollectionView.dataSource = self
        onboardingCollectionView.register(UINib(nibName: "OnboardingCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "OnboardingCollectionViewCell")
    }
}

extension OnboardingViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "OnboardingCollectionViewCell", for: indexPath) as! OnboardingCollectionViewCell
        cell.onboardingImage.image = UIImage(named: images[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: onboardingCollectionView.frame.size.width, height: onboardingCollectionView.frame.size.height)
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let page = Int(targetContentOffset.pointee.x / self.view.bounds.width)
        self.pageControl.currentPage = page
        nowPage = page
    }
}
