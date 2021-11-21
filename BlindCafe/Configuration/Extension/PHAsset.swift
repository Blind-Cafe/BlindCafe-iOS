//
//  PHAsset.swift
//  BlindCafe
//
//  Created by 권하은 on 2021/11/09.
//

import Foundation
import UIKit
import Photos

extension PHAsset {
    var thumbnailImage: UIImage {
        get {
            let manager = PHImageManager.default()
            let option = PHImageRequestOptions()
            var thumbnail = UIImage()
            option.isSynchronous = true
            manager.requestImage(for: self, targetSize: CGSize(width: 100, height: 100), contentMode: .aspectFill, options: option, resultHandler: {(result, info) -> Void in
                thumbnail = result!
            })
            return thumbnail
        }
    }
}
