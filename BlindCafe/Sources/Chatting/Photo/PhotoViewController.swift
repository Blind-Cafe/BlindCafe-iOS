//
//  PhotoViewController.swift
//  BlindCafe
//
//  Created by 권하은 on 2021/11/09.
//

import UIKit
import Photos

struct AlbumModel {
    let name: String
    let photoAssets: PHFetchResult<PHAsset>
}

class PhotoViewController: UIViewController {

    @IBOutlet weak var albumListTableView: UITableView!
    @IBOutlet weak var photoCollectionView: UICollectionView!
    
    var album: [AlbumModel] = [AlbumModel]()
    var albumIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .charcol
        
        albumListTableView.delegate = self
        albumListTableView.dataSource = self
        
        albumListTableView.register(UINib(nibName: "albumListTableViewCell", bundle: nil), forCellReuseIdentifier: "albumListTableViewCell")
        
        photoCollectionView.delegate = self
        photoCollectionView.dataSource = self
        
        photoCollectionView.register(UINib(nibName: "photoCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "photoCollectionViewCell")
        
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

extension PhotoViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return album.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "albumListTableViewCell", for: indexPath) as! albumListTableViewCell
        
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
    }
}

extension PhotoViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return album[albumIndex].photoAssets.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "photoCollectionViewCell", for: indexPath) as! photoCollectionViewCell
        
        let asset = album[albumIndex].photoAssets.object(at: indexPath.row)
        
        cell.fetchImage(asset: asset, contentMode: .aspectFill, targetSize: cell.imageView.frame.size)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (view.frame.size.width / 3) - 7, height: (view.frame.size.width / 3) - 7)
    }
    
}
