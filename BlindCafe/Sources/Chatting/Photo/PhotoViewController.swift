//
//  PhotoViewController.swift
//  BlindCafe
//
//  Created by 권하은 on 2021/11/09.
//

import UIKit
import Photos
import FirebaseStorage

struct AlbumModel {
    let name: String
    let photoAssets: PHFetchResult<PHAsset>
}

class PhotoViewController: UIViewController {
    
    let storage = Storage.storage()
    
    @IBOutlet weak var sendButton: UIButton!
    @IBAction func sendButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
        for i in 0...(photoList.count - 1) {
            uploadimage(img: photoList[i])
        }
    }
    
    func uploadimage(img: UIImage) {
        var data = Data()
        data = img.jpegData(compressionQuality: 1)!
        
        let time = Int64(Date().timeIntervalSince1970 * 1000)
        let filePath = "image/\(time)\(UserDefaults.standard.string(forKey: "UserID") ?? "")"
        let metaData = StorageMetadata()
        metaData.contentType = "image/jpeg"
        let uploadTask = storage.reference().child(filePath).putData(data, metadata: metaData) { (metaData, error) in
            if let error = error {
                print(error.localizedDescription)
                return
            } else {
                print("성공")
            }
        }
        _ = uploadTask.observe(.success) {snapshot in
            ChattingViewController().send(contents: "\(time)\(UserDefaults.standard.string(forKey: "UserID") ?? "")", type: 2)
        }
        
        //uploadTask.removeAllObservers()
        //ChattingViewController().loadMessages()
    }
    
    @IBOutlet weak var galleryButton: UIButton!
    @IBAction func galleryButton(_ sender: UIButton) {
        if selectedIndex.count != 0 {
            for i in 0...(selectedIndex.count - 1) {
                let cell1 = photoCollectionView.cellForItem(at: selectedIndex[i]) as! photoCollectionViewCell
                cell1.photoSelectButton.image = UIImage(named: "photoselect")
            }
        }
        selectedIndex.removeAll()
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
    
    @IBOutlet weak var albumListTableView: UITableView!
    @IBOutlet weak var photoCollectionView: UICollectionView!
    
    var selectedIndex: [IndexPath] = []
    var photoNumber: [Int] = [1, 2, 3, 4, 5]
    
    var photoList: [UIImage] = []
    
    var album: [AlbumModel] = [AlbumModel]()
    var albumIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .charcol
        
        sendButton.isHidden = true
        galleryButton.isEnabled = false
        
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

//MARK: TableView
extension PhotoViewController: UITableViewDelegate, UITableViewDataSource {
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
extension PhotoViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return album[albumIndex].photoAssets.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "photoCollectionViewCell", for: indexPath) as! photoCollectionViewCell
        
        let asset = album[albumIndex].photoAssets.object(at: indexPath.row)
        
        cell.fetchImage(asset: asset, contentMode: .aspectFill, targetSize: CGSize(width: 1000, height: 1000))
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! photoCollectionViewCell
        
        if selectedIndex.count < 5 {
            if !selectedIndex.contains(indexPath) {
                selectedIndex.append(indexPath)
                photoList.append(cell.imageView.image!)
                let index = selectedIndex.firstIndex(of: indexPath)
                cell.photoSelectButton.image = UIImage(named: "photo\(String(index! + 1))")
                print("photo\(String(index! + 1))")
            }
            else {
                selectedIndex.removeAll(where: { $0 == indexPath} )
                photoList.removeAll(where: { $0 == cell.imageView.image! })
                cell.photoSelectButton.image = UIImage(named: "photoselect")
                if selectedIndex.count != 0 {
                    for i in 0...(selectedIndex.count - 1) {
                        let cell1 = collectionView.cellForItem(at: selectedIndex[i]) as! photoCollectionViewCell
                        cell1.photoSelectButton.image = UIImage(named: "photo\(String(i + 1))")
                    }
                }
            }
        }
        else {
            selectedIndex.removeAll(where: { $0 == indexPath} )
            photoList.removeAll(where: { $0 == cell.imageView.image! })
            cell.photoSelectButton.image = UIImage(named: "photoselect")
            for i in 0...(selectedIndex.count - 1) {
                let cell1 = collectionView.cellForItem(at: selectedIndex[i]) as! photoCollectionViewCell
                cell1.photoSelectButton.image = UIImage(named: "photo\(String(i + 1))")
            }
        }
        
        if selectedIndex.count != 0 {
            sendButton.isHidden = false
        }
        else {
            sendButton.isHidden = true
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (view.frame.size.width / 3) - 4, height: (view.frame.size.width / 3) - 4)
    }
    
}

