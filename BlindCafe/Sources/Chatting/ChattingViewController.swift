//
//  ChattingViewController.swift
//  BlindCafe
//
//  Created by 권하은 on 2021/11/03.
//

import UIKit
import FirebaseFirestore
import Photos
import Alamofire
import FirebaseStorageUI
import Firebase
import SDWebImage
import AVFoundation

struct Message {
    let sender: String
    let body: String
    let time: String
    let type: Int
}

class ChattingViewController: BaseViewController {
    
    var matchingId: Int = UserDefaults.standard.integer(forKey: "MatchingId")
    var partnerName: String = ""
    
    var keyboardFrameHeight: CGFloat = 0
    
    let db = Firestore.firestore()
    
    var messages: [Message] = []
    
    let storageRef = Storage.storage().reference()
    let storage = Storage.storage()
    
    var audioRecorder: AVAudioRecorder!
    var player: AVAudioPlayer!
    var audioSelected: Int!
    
    private lazy var recordURL: URL = {
        var documentsURL: URL = {
            let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
            return paths.first!
        }()
        let time = Int64(Date().timeIntervalSince1970 * 1000)
        let fileName = "\(time)\(UserDefaults.standard.string(forKey: "UserID") ?? "")"
        let url = documentsURL.appendingPathComponent(fileName)
        return url
    }()
    
    //Top
    @IBOutlet weak var menuView: UIView!
    @IBOutlet weak var recordView: UIView!
    
    
    @IBAction func reportButton(_ sender: Any) {
        let vc = ReportViewController()
        
        present(vc, animated: false)
        
    }
    @IBAction func leaveroomButton(_ sender: Any) {
    }

    //TableView
    @IBOutlet weak var chatTableView: UITableView!
    
    //Toolbar
    @IBOutlet weak var customToolbar: UIView!
    @IBOutlet weak var toolbarBottomConstraint: NSLayoutConstraint!
    var toolbarBottomConstraintInitialValue: CGFloat?
    
    @IBOutlet weak var photoButton: UIButton!
    @IBAction func photoButton(_ sender: Any) {
        let vc = PhotoViewController()
        vc.modalPresentationStyle = .pageSheet
        present(vc, animated: true)
    }
    @IBOutlet weak var recordButton: UIButton!

    @IBOutlet weak var chattingField: UIImageView!
    @IBOutlet weak var chattingTextField: UITextView!
    @IBOutlet weak var sendButton: UIButton!
   
    @IBOutlet weak var chattingFieldConstraint: NSLayoutConstraint!
    @IBOutlet weak var tableViewBottom: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        recordView.isHidden = true
        
        view.backgroundColor = .black2
        
        navigationController?.navigationBar.isHidden = false
        menuView.isHidden = true

        self.toolbarBottomConstraintInitialValue = toolbarBottomConstraint?.constant
        enableKeyboardHideOnTap()
        
        chatTableView.register(UINib(nibName: "TextTableViewCell", bundle: nil), forCellReuseIdentifier: "TextTableViewCell")
        chatTableView.register(UINib(nibName: "ImageSendingTableViewCell", bundle: nil), forCellReuseIdentifier: "ImageSendingTableViewCell")
        chatTableView.register(UINib(nibName: "ImageReceivingTableViewCell", bundle: nil), forCellReuseIdentifier: "ImageReceivingTableViewCell")
        chatTableView.register(UINib(nibName: "AudioSendingTableViewCell", bundle: nil), forCellReuseIdentifier: "AudioSendingTableViewCell")
        chatTableView.register(UINib(nibName: "AudioReceivingTableViewCell", bundle: nil), forCellReuseIdentifier: "AudioReceivingTableViewCell")
        
        chatTableView.delegate = self
        chatTableView.dataSource = self
        chatTableView.separatorStyle = .none
        chatTableView.backgroundColor = .mainBlack
        chatTableView.rowHeight = UITableView.automaticDimension
        
        chattingTextField.delegate = self
        
        if chattingTextField.text == "" {
            sendButton.isEnabled = false
        }
        
        chattingTextField.textColor = .white
        chatTableView.frame.origin.y = 0
        
        loadMessages()
        navigationbarCustom(title: "\(partnerName)")
        
        recordButton.addTarget(self, action: #selector(buttonDown), for: .touchDown)
        recordButton.addTarget(self, action: #selector(buttonUp), for: [.touchUpInside, .touchUpOutside])
        
        //chattingTextField.becomeFirstResponder()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        requestMicrophoneAccess { [weak self] allowed in
            if allowed {
                // If permission is granted...
            } else {
                //self?.showSettingsAlert()
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        removeKeyboardNotification()
    }
    
    @objc func buttonDown() {
        recordView.isHidden = false
        record()
    }
    
    @objc func buttonUp() {
        recordView.isHidden = true
        stopRecord()
    }

    func requestMicrophoneAccess(completion: @escaping (Bool) -> Void) {
        let audioSession: AVAudioSession = AVAudioSession.sharedInstance()
        switch audioSession.recordPermission {
        case .undetermined:
            // 아직 녹음 권한 요청이 되지 않음, 사용자에게 권한 요청
            audioSession.requestRecordPermission({ allowed in completion(allowed) })
        case .denied:
            // 사용자가 녹음 권한 거부, 사용자가 직접 설정 화면에서 권한 허용을 하게끔 유도
            print("[Failure] Record Permission is Denied.")
            completion(false)
        case .granted:
            // 사용자가 녹음 권한 허용
            print("[Success] Record Permission is Granted.")
            completion(true)
        @unknown default:
            fatalError("[ERROR] Record Permission is Unknown Default.")
        }
    }
    
    //MARK: NavigationBar
    func navigationbarCustom(title: String) {
        navigationController?.navigationBar.isHidden = false
        navigationController?.navigationBar.tintColor = .veryLightPink
        navigationController?.navigationBar.barTintColor = .mainBlack
        
        let backButton: UIButton = UIButton()
        backButton.setImage(UIImage(named: "backbutton"), for: .normal)
        backButton.addTarget(self, action: #selector(popToHome), for: .touchUpInside)
        backButton.frame = CGRect(x: 18, y: 0, width: 44, height: 44)
        let addBackButton = UIBarButtonItem(customView: backButton)
        
        let nameLabel = UILabel()
        nameLabel.numberOfLines = 1
        nameLabel.textAlignment = .left
        nameLabel.font = UIFont.SpoqaSans(.bold, size: 16)
        nameLabel.textColor = .veryLightPink
        nameLabel.text = title
        nameLabel.sizeToFit()
        let addNameLabel = UIBarButtonItem(customView: nameLabel)
        
        let bellButton: UIButton = UIButton()
        bellButton.setImage(UIImage(named: "bellbutton"), for: .normal)
        bellButton.addTarget(self, action: #selector(bellButtonAction), for: .touchUpInside)
        
        let menuButton: UIButton = UIButton()
        menuButton.setImage(UIImage(named: "menubutton"), for: .normal)
        menuButton.addTarget(self, action: #selector(menuButtonAction), for: .touchUpInside)
        
        let stackView = UIStackView.init(arrangedSubviews: [bellButton, menuButton])
        stackView.distribution = .equalSpacing
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.spacing = 0
        let rightBarButton = UIBarButtonItem(customView: stackView)
        
        self.navigationItem.setLeftBarButtonItems([addBackButton, addNameLabel], animated: false)
        self.navigationItem.rightBarButtonItem = rightBarButton
    }
    
    @objc func popToHome(){
        navigationController?.popToRootViewController(animated: true)
    }
    
    @objc func bellButtonAction() {
        
    }
    
    @objc func menuButtonAction() {
        if menuView.isHidden {
            menuView.isHidden = false
        }
        else {
            menuView.isHidden = true
        }
    }
    
    @objc func textFieldDidChange(_sender: Any?) {
        
        if chattingTextField.text == "" {
            sendButton.isEnabled = false
            photoButton.isHidden = false
            recordButton.isHidden = false
        }
        else {
            sendButton.isEnabled = true
            photoButton.isHidden = true
            recordButton.isHidden = true
        }
        
        if chattingTextField.text != "" {
            chattingFieldConstraint.constant = 18
        }
        else {
            chattingFieldConstraint.constant = 112
        }
    }
    
    
}

//MARK: Audio
extension ChattingViewController: AVAudioRecorderDelegate {
    func record() {
        do {
            let directoryURL = FileManager.default.urls(for: FileManager.SearchPathDirectory.documentDirectory, in: FileManager.SearchPathDomainMask.userDomainMask).first
            let audioFileName = UUID().uuidString + ".m4a"
            let audioFileURL = directoryURL!.appendingPathComponent(audioFileName)
            
            let session = AVAudioSession.sharedInstance()
            try session.setCategory(.playAndRecord)
            audioRecorder = try AVAudioRecorder(url: audioFileURL, settings: [:])
            audioRecorder.delegate = self
            try? session.setActive(true)
            audioRecorder.record()
            print("record")
        } catch(let error) {
            print("record error: \(error)")
        }
    }
    
    func stopRecord() {
        audioRecorder.stop()
        try? AVAudioSession.sharedInstance().setActive(false)
        uploadAudio(audio: audioRecorder.url)
    }
    
    func uploadAudio(audio: URL) {
        let audioData = (try? Data(contentsOf: audio))!
        
        let time = Int64(Date().timeIntervalSince1970 * 1000)
        let filePath = "audio/\(time)\(UserDefaults.standard.string(forKey: "UserID") ?? "")"
        let metaData = StorageMetadata()
        metaData.contentType = "audio/m4a"
        let uploadTask = storage.reference().child(filePath).putData(audioData, metadata: metaData) { (metaData, error) in
            if let error = error {
                print(error.localizedDescription)
                return
            } else {
                print("성공")
            }
        }
        _ = uploadTask.observe(.success) {snapshot in
            ChattingViewController().send(contents: "\(time)\(UserDefaults.standard.string(forKey: "UserID") ?? "")", type: 3)
        }
    }

}


extension ChattingViewController: AVAudioPlayerDelegate {
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        if flag {
            print("asdfasdf")
        }
    }
}

//MARK: TextViewDelegate
extension ChattingViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        if chattingTextField.text == "" {
            sendButton.isEnabled = false
            photoButton.isHidden = false
            recordButton.isHidden = false
        }
        else {
            sendButton.isEnabled = true
            photoButton.isHidden = true
            recordButton.isHidden = true
        }
        
        if chattingTextField.text != ""{
            chattingFieldConstraint.constant = 18
        }
        else {
            chattingFieldConstraint.constant = 112
        }
        
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if chattingTextField.text == "" {
            sendButton.isEnabled = false
            photoButton.isHidden = false
            recordButton.isHidden = false
        }
        else {
            sendButton.isEnabled = true
            photoButton.isHidden = true
            recordButton.isHidden = true
        }
        
        if chattingTextField.text != "" {
            chattingFieldConstraint.constant = 18
        }
        else {
            chattingFieldConstraint.constant = 112
        }
    }
    
}

//MARK: TableView
extension ChattingViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var isAfter = true
        if messages.count > 2 && indexPath.row > 0 {
            if messages[indexPath.row - 1].sender == messages[indexPath.row].sender {
                isAfter = true
            }
            else {
                isAfter = false
            }
        }
        
        let message = messages[indexPath.row]
        
        if message.type == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "TextTableViewCell", for: indexPath) as! TextTableViewCell
            cell.selectionStyle = .none
            
            if message.sender != partnerName {
                cell.receivingMessageView.isHidden = true
                cell.receivingStackView.isHidden = true
                cell.receivingTime.isHidden = true
                cell.sendingMessageView.isHidden = false
                cell.sendingStackView.isHidden = false
                cell.sendingTime.isHidden = false
                
                cell.sendingMessageLabel.text = message.body
                cell.sendingTime.text = message.time
                
                if isAfter {
                    cell.sendingTopConstraint.constant = 4
                }
                else {
                    cell.sendingTopConstraint.constant = 12
                }
            }
            else {
                cell.sendingMessageView.isHidden = true
                cell.sendingStackView.isHidden = true
                cell.sendingTime.isHidden = true
                cell.receivingMessageView.isHidden = false
                cell.receivingStackView.isHidden = false
                cell.receivingTime.isHidden = false
                
                cell.receivingMessageLabel.text = message.body
                cell.receivingTime.text = message.time
                
                if isAfter {
                    cell.receivingTopConstraint.constant = 4
                }
                else {
                    cell.receivingTopConstraint.constant = 12
                }
            }
            return cell
        }
        else if message.type == 2 {
            let image = Storage.storage().reference(forURL: "gs://blind-cafe.appspot.com/image/\(message.body)")
            
            if message.sender != partnerName {
                let cell = tableView.dequeueReusableCell(withIdentifier: "ImageSendingTableViewCell", for: indexPath) as! ImageSendingTableViewCell
                cell.selectionStyle = .none
        
                cell.sendingImageView.sd_setImage(with: image)
                
                cell.sendingTime.text = message.time
                cell.layoutSubviews()
                
                chatTableView.reloadRows(at: [indexPath], with: .automatic)
                return cell
            }
            else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "ImageReceivingTableViewCell", for: indexPath) as! ImageReceivingTableViewCell
                cell.selectionStyle = .none
                
                cell.receivingImageView.sd_setImage(with: image)
                
                cell.receivingTime.text = message.time
                cell.layoutSubviews()
                chatTableView.reloadRows(at: [indexPath], with: .automatic)
                return cell
            }
            
        }
        else {
            if message.sender != partnerName {
                let cell = tableView.dequeueReusableCell(withIdentifier: "AudioSendingTableViewCell", for: indexPath) as! AudioSendingTableViewCell
                cell.playStopButton.content = String(message.body)
                
                cell.playStopButton.addTarget(self, action: #selector(playStop(_:)), for: .touchUpInside)
                return cell
            }
            else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "AudioReceivingTableViewCell", for: indexPath) as! AudioReceivingTableViewCell
                cell.playstopButton.addTarget(self, action: #selector(playStop(_:)), for: .touchUpInside)
                return cell
            }
        }
    }
    
    @objc func playStop(_ sender: Any) {
        
        if let player = player, player.play() {
            (sender as! PlayStopButton).isSelected = false
            
            player.pause()
        }
        else {
            (sender as! PlayStopButton).isSelected = true
            let audioRef = storageRef.child("audio/\((sender as! PlayStopButton).content)")
            audioRef.downloadURL { url, error in
                if let error = error {
                    print(error.localizedDescription)
                } else {
                    do{
                        try AVAudioSession.sharedInstance().setMode(.default)
                        try AVAudioSession.sharedInstance().setActive(true, options: .notifyOthersOnDeactivation)
                        
                        guard let urlString = url else {
                            return
                        }
                        
                        
                        
                    } catch {
                        print("something went wrong")
                    }
                }
            }
            
        }
        
    }
    
}

//MARK: Firestore 채팅
extension ChattingViewController {
    @IBAction func sendMessage(_ sender: Any) {
        if chattingTextField.text != nil && !chattingTextField.text!.isEmpty {
            if let messageBody = chattingTextField.text {
                db.collection("Rooms/\(matchingId)/Messages").addDocument(data: [
                    "contents": messageBody,
                    "senderName": "\(String(describing: UserDefaults.standard.string(forKey: "UserNickname")!))",
                    "senderUid": "\(String(describing: UserDefaults.standard.integer(forKey: "UserId")))",
                    "timestamp": Date(),
                    "type": 1
                ]) { (error) in
                    if let e = error {
                        print(e.localizedDescription)
                    } else {
                        print("Success save data")
                        
                        DispatchQueue.main.async {
                            self.chattingTextField.text = ""
                        }
                    }
                }
            }
        }
        
        sendButton.isEnabled = false
        photoButton.isHidden = false
        recordButton.isHidden = false
        chattingFieldConstraint.constant = 112
    }
    
    func send(contents: String, type: Int) {
        db.collection("Rooms/\(matchingId)/Messages").addDocument(data: [
            "contents": contents,
            "senderName": "\(String(describing: UserDefaults.standard.string(forKey: "UserNickname")!))",
            "senderUid": "\(String(describing: UserDefaults.standard.integer(forKey: "UserId")))",
            "timestamp": Date(),
            "type": type
        ]) { (error) in
            if let e = error {
                print(e.localizedDescription)
            } else {
                print("Success save data")
            }
        }
    }
    
    func loadMessages() {
        db.collection("Rooms/\(matchingId)/Messages")
            .order(by: "timestamp")
            .addSnapshotListener { (querySnapshot, error) in
                self.messages = []
                
                if let e = error {
                    print(e.localizedDescription)
                } else {
                    if let snapshotDocuments = querySnapshot?.documents {
                        snapshotDocuments.forEach { (doc) in
                            let data = doc.data()
                            if let sender = data["senderName"] as? String, let body = data["contents"] as? String, let timestamp = data["timestamp"] as? Timestamp, let type = data["type"] as? Int {
                                let time = self.timeFormatter(timestamp: timestamp)
                                self.messages.append(Message(sender: sender, body: body, time: time, type: type))
                                
                                DispatchQueue.main.async {
                                    self.chatTableView.reloadData()
                                    let indexPath = IndexPath(row: self.messages.count - 1, section: 0)
                                    self.chatTableView.scrollToRow(at: indexPath, at: .bottom, animated: false)
                                }
                            }
                        }
                    }
                }
                
            }
    }
    
    
    func timeFormatter(timestamp: Timestamp) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ko_KR")
        dateFormatter.dateFormat = "a hh:mm"
        //let date = Date(timeIntervalSince1970: dd)
        let date = timestamp.dateValue()
        return dateFormatter.string(from: date)
    }
}

//MARK: KeyboardToolbar
extension ChattingViewController {
    private func enableKeyboardHideOnTap(){
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        dismissWhenTappedAround()
       }
    
    func dismissWhenTappedAround() {
        let tap: UITapGestureRecognizer =
            UITapGestureRecognizer(target: self, action: #selector(self.dismissAll))
        //tap.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tap)
    }
    
    @objc func dismissAll() {
        self.view.endEditing(false)
        self.menuView.isHidden = true
    }

    @objc func keyboardWillShow(notification: NSNotification) {

        let info = notification.userInfo!

        let keyboardFrame: NSValue = info[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue
        let keyboardRectangle = keyboardFrame.cgRectValue
        let keyboardHeight = keyboardRectangle.height
        keyboardFrameHeight = keyboardRectangle.height
        toolbarBottomConstraint.constant = (keyboardHeight - view.safeAreaInsets.bottom)
        //tableViewBottom.constant = keyboardHeight
        //chatTableView.frame.origin.y = -keyboardHeight - customToolbar.frame.height
        //chatTableView.setContentOffset(CGPoint(x: 0, y: keyboardHeight + customToolbar.frame.height), animated: true)
        chatTableView.contentInset.bottom = keyboardHeight - view.safeAreaInsets.bottom
        if messages.count > 0 {
            chatTableView.scrollToRow(at: [0, messages.count - 1], at: .bottom, animated: false)
        }
        
        self.view.layoutSubviews()
        

        
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        chatTableView.contentInset.bottom = -view.safeAreaInsets.bottom
        toolbarBottomConstraint.constant = 0
        chatTableView.frame.origin.y = 0
        self.view.layoutSubviews()
        
    }
    
    
    func removeKeyboardNotification() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)

    }
}
