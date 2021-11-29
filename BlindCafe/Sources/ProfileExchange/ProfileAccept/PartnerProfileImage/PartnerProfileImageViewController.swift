//
//  PartnerProfileImageViewController.swift
//  BlindCafe
//
//  Created by 권하은 on 2021/11/30.
//

import UIKit

class PartnerProfileImageViewController: BaseViewController {
    
    var id: Int = 0

    @IBAction func dismissButton(_ sender: Any) {
        dismiss(animated: false, completion: nil)
    }
    
    @IBOutlet weak var imageCollectionView: UICollectionView!
    
    var images: [String] = []
    
    @IBOutlet weak var pageControl: UIPageControl!
    var nowPage: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(hex: 0x000000, alpha: 0.5)
        
        imageCollectionView.delegate = self
        imageCollectionView.dataSource = self
        imageCollectionView.register(UINib(nibName: "PartnerImageCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "PartnerImageCollectionViewCell")
        
        showIndicator()
        
        PartnerImagesDataManager().requestHome(id: id, viewController: self)
    }

}

extension PartnerProfileImageViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PartnerImageCollectionViewCell", for: indexPath) as! PartnerImageCollectionViewCell
        
        if images.count != 0 {
            let url = URL(string: images[indexPath.row])
            let data = try? Data(contentsOf: url!)
            cell.partnerImageView.image = UIImage(data: data!)
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 236, height: 340)
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let page = Int(targetContentOffset.pointee.x / 236)
        self.pageControl.currentPage = page
        nowPage = page
    }
}

extension PartnerProfileImageViewController {
    func getImage(result: PartnerImageResponse) {
        dismissIndicator()
        
        pageControl.numberOfPages = result.images.count
        
        images = result.images
        imageCollectionView.reloadData()
    }
}
