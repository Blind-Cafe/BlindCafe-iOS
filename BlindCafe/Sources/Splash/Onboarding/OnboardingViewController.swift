//
//  OnboardingViewController.swift
//  BlindCafe
//
//  Created by 권하은 on 2021/10/25.
//

import UIKit

class OnboardingViewController: BaseOnboardingViewController {

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
        pageChange()
    }
    
    var images = ["onboarding1", "onboarding2", "onboarding3", "onboarding4"]
    var textImages = ["onboardingtext1", "onboardingtext2", "onboardingtext3", "onboardingtext4"]
    override func viewDidLoad() {
        super.viewDidLoad()
        
        onboardingCollectionView.delegate = self
        onboardingCollectionView.dataSource = self
        onboardingCollectionView.register(UINib(nibName: "OnboardingCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "OnboardingCollectionViewCell")
        pageChange()
    }
    
    func pageChange() {
        if #available(iOS 14.0, *) {
            pageControl.setIndicatorImage(UIImage(named: "indicator2"), forPage: nowPage)
            for i in 0...3 {
                if i != nowPage {
                    pageControl.setIndicatorImage(UIImage(named: "indicator1"), forPage: i)
                }
            }
        }
    }
}

extension OnboardingViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "OnboardingCollectionViewCell", for: indexPath) as! OnboardingCollectionViewCell
        cell.onboardingImage.image = UIImage(named: images[indexPath.row])
        cell.textImage.image = UIImage(named: textImages[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: onboardingCollectionView.frame.size.width, height: onboardingCollectionView.frame.size.height)
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let page = Int(targetContentOffset.pointee.x / self.view.bounds.width)
        self.pageControl.currentPage = page
        nowPage = page
        pageChange()
    }
}
