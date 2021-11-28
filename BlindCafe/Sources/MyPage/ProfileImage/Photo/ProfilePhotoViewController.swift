//
//  ProfilePhotoViewController.swift
//  BlindCafe
//
//  Created by 권하은 on 2021/11/22.
//

import UIKit
import Photos

class ProfilePhotoViewController: BaseViewController{
    
    var delegate: GetImage?
    
    @IBAction func closeButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    var selectedfield = 0
    
    @IBOutlet weak var albumListTableView: UITableView!
    @IBOutlet weak var photoCollectionView: UICollectionView!

    var photoList: [UIImage] = []
    
    var album: [AlbumModel] = [AlbumModel]()
    var albumIndex = 0
    
    @IBOutlet weak var galleryButton: UIButton!
    @IBAction func galleryButton(_ sender: UIButton) {
        if sender.isEnabled == true {
            sender.isEnabled = false
            albumListTableView.isHidden = false
            photoCollectionView.isHidden = true
        }
        else {
            sender.isEnabled = true
            albumListTableView.isHidden = true
            photoCollectionView.isHidden = false
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .charcol
        
        albumListTableView.delegate = self
        albumListTableView.dataSource = self
        
        albumListTableView.register(UINib(nibName: "albumListTableViewCell", bundle: nil), forCellReuseIdentifier: "albumListTableViewCell")
        
        photoCollectionView.delegate = self
        photoCollectionView.dataSource = self
        photoCollectionView.register(UINib(nibName: "ProfilePhotoCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "ProfilePhotoCollectionViewCell")
        
        let userCollections = PHAssetCollection.fetchAssetCollections(with: .album, subtype: .any, options: PHFetchOptions())
        userCollections.enumerateObjects{ (object: AnyObject!, count: Int, stop: UnsafeMutablePointer) in
            if object is PHAssetCollection {
                let obj : PHAssetCollection = object as! PHAssetCollection
                
                let fetchOptions = PHFetchOptions()
                fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
                
                var photoAssets = PHFetchResult<PHAsset>()
                photoAssets = PHAsset.fetchAssets(in: obj, options: fetchOptions)
                
                fetchOptions.predicate = NSPredicate(format: "mediaType = %d", PHAssetMediaType.image.rawValue)
                
                let newAlbum = AlbumModel(name: obj.localizedTitle!, photoAssets: photoAssets)
                self.album.append(newAlbum)
            }
        }
        let allPhotoAlbum = AlbumModel(name: "전체 항목", photoAssets: allPhotos!)
        album.insert(allPhotoAlbum, at: 0)
        
        albumListTableView.isHidden = false
        photoCollectionView.isHidden = true
        
        albumListTableView.backgroundColor = .charcol
        albumListTableView.separatorInset = UIEdgeInsets(top: 0, left: 1500, bottom: 0, right: 0)
        photoCollectionView.backgroundColor = .charcol
    }


}

extension ProfilePhotoViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return album.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "albumListTableViewCell", for: indexPath) as! albumListTableViewCell
        
        cell.backgroundColor = .charcol
        cell.albumName.text = album[indexPath.row].name
        if album[indexPath.row].photoAssets.firstObject?.thumbnailImage != nil {
            cell.thumbnailImage.image = album[indexPath.row].photoAssets.firstObject!.thumbnailImage
        } else {
            cell.thumbnailImage.image = UIImage(named: "mypageitem")
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        albumIndex = indexPath.row
        photoCollectionView.reloadData()
        tableView.isHidden = true
        photoCollectionView.isHidden = false
        galleryButton.isEnabled = true
    }
}

//MARK: CollectionView
extension ProfilePhotoViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return album[albumIndex].photoAssets.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProfilePhotoCollectionViewCell", for: indexPath) as! ProfilePhotoCollectionViewCell
        
        let asset = album[albumIndex].photoAssets.object(at: indexPath.row)
        
        cell.fetchImage(asset: asset, contentMode: .aspectFill, targetSize: CGSize(width: 1000, height: 1000))
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! ProfilePhotoCollectionViewCell
        
        UploadProfileImage().uploadImage(priority: selectedfield, image: cell.imageView.image ?? UIImage())
        print(cell.imageView.image)
        self.delegate?.getImage(selectedField: selectedfield, profileImage: cell.imageView.image ?? UIImage())
        self.dismiss(animated: true, completion: nil)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (view.frame.size.width / 3) - 4, height: (view.frame.size.width / 3) - 4)
    }
    
}
