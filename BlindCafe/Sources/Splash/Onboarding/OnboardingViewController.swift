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
    
    var texts: [NSAttributedString] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let text1 = "3일간의 대화로 설렘을 느껴보세요.\n언제든지 새로운 상대와 대화를 시작할 수 있습니다.\n단, 한 번에 한 사람과 대화할 수 있습니다."
        let attributed1 = NSMutableAttributedString(string: text1)
        attributed1.addAttribute(.foregroundColor, value: UIColor.mainGreen, range: (text1 as NSString).range(of: "3일"))
        attributed1.addAttribute(.foregroundColor, value: UIColor.mainGreen, range: (text1 as NSString).range(of: "한 번에 한 사람"))
        
        let text2 = "시간이 흐를수록 대화의 제약이 풀려갑니다.\n첫째날엔 대화를 둘째날엔 사진을 셋째날엔 음성을 전송할 수 있습니다."
        let attributed2 = NSMutableAttributedString(string: text2)
        attributed2.addAttribute(.foregroundColor, value: UIColor.mainGreen, range: (text2 as NSString).range(of: "첫째 날에 대화를 둘째 날엔 사진을 셋째날엔 음성을 전송"))
        
        let text3 = "72시간의 대화 후 프로필을 교환해 상대방을 확인해보세요.\n당신의 정보는 프로필 교환 전까지 공개되지 않습니다."
        let attributed3 = NSMutableAttributedString(string: text3)
        attributed3.addAttribute(.foregroundColor, value: UIColor.mainGreen, range: (text3 as NSString).range(of: "72시간의 대화 후 프로필을 교환"))
        
        let text4 = NSMutableAttributedString(string: "프로필을 교환한 상대는 이제 추억을 쌓은 친구가 됐습니다. 대화 테이블에서 친구와 자유롭게 대화하세요.")
        
        texts = [attributed1, attributed2, attributed3, text4]
        
        self.navigationController?.navigationBar.barTintColor = .mainBlack
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont.SpoqaSans(.bold, size: 16), NSAttributedString.Key.foregroundColor: UIColor.veryLightPink]
        
        let titleview = UIView(frame: CGRect(x: 0, y: 0, width: 130, height: 44))
        let titleLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 130, height: 44))
        titleLabel.text = "블라인드 카페 규칙"
        titleLabel.font = .SpoqaSans(.bold, size: 16)
        titleLabel.textColor = .white2
        titleLabel.textAlignment = .center
        titleview.addSubview(titleLabel)
        self.navigationItem.titleView = titleview
        
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
        cell.onboardingLabel.attributedText = texts[indexPath.row]
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
