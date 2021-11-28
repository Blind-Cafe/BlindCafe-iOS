//
//  UploadProfileImage.swift
//  BlindCafe
//
//  Created by 권하은 on 2021/11/28.
//

import Foundation
import Alamofire

struct UploadProfileImage {
    static let shared = UploadProfileImage()
    
    func uploadImage (priority: Int, image: UIImage) {
        let URL = "\(Constant.BASE_URL)/api/user/image"
        let header : HTTPHeaders = Constant.HEADERS
        
        let parameters: [String : Any] = [
                   "priority": priority,
                   "image": image
               ]
        
        AF.upload(multipartFormData: { multipartFormData in
            for (key, value) in parameters {
                multipartFormData.append("\(value)".data(using: .utf8)!, withName: key)
            }
            if let image = image.jpegData(compressionQuality: 0.5) {
                multipartFormData.append(image, withName: "image", fileName: "\(image).jpeg", mimeType: "image/jpeg")
            }
        }, to: URL, usingThreshold: UInt64.init(), method: .patch, headers: header).response { response in
            guard let statusCode = response.response?.statusCode,
                statusCode == 200
            else { return }
        }
    }
}
