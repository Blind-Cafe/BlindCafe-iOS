//
//  ProfilePhotoCollectionViewCell.swift
//  BlindCafe
//
//  Created by 권하은 on 2021/11/27.
//

import UIKit
import Photos

class ProfilePhotoCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var imageView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func fetchImage(asset: PHAsset, contentMode: PHImageContentMode, targetSize: CGSize) {
        let options = PHImageRequestOptions()
        options.version = .original
        PHImageManager.default().requestImage(for: asset, targetSize: targetSize, contentMode: contentMode, options: options) { image, _ in
            guard let image = image else { return }
            self.contentMode = .scaleAspectFill
            self.imageView.image = image
        }
    }
}
