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

struct AudioModel {
    var url: String
    var index: Int
    var duration: Int
    var isSending: Bool
}

class ChattingViewController: BaseViewController {
    
    var startTime: String = ""
    @IBOutlet weak var timeLabel: UILabel!
    
    var matchingId: Int = UserDefaults.standard.integer(forKey: "MatchingId")
    var partnerName: String = ""
    
    var keyboardFrameHeight: CGFloat = 0
    
    let db = Firestore.firestore()
    
    var messages: [Message] = []
    
    var audioPlaying: AudioModel?
    
    let storageRef = Storage.storage().reference()
    let storage = Storage.storage()
    
    var audioRecorder: AVAudioRecorder!
    var audioPlayer: AVAudioPlayer!
    
    var recordTimer: Timer!
    lazy var pencil = UIBezierPath(rect: waveView.bounds)
    lazy var firstPoint = CGPoint(x: 6, y: waveView.bounds.midY)
    lazy var jump: CGFloat = (waveView.bounds.width - (firstPoint.x * 2)) / 200
    let waveLayer = CAShapeLayer()
    var traitLength: CGFloat!
    var start: CGPoint!
    
    @IBOutlet weak var recordScrollView: UIScrollView!
    @IBOutlet weak var waveView: UIView!
    @IBOutlet weak var waveViewWidth: NSLayoutConstraint!
    @IBOutlet weak var recoredTimeLabel: UILabel!
    
    var audioPlayingIndex: Int!
    var playing: Int!
    
    //Top
    @IBOutlet weak var menuView: UIView!
    @IBOutlet weak var recordView: UIView!
    
    @IBAction func reportButton(_ sender: Any) {
        menuView.isHidden = true
        let vc = ReportViewController()
        vc.modalPresentationStyle = .overCurrentContext
        vc.modalTransitionStyle = .crossDissolve
        
        present(vc, animated: false)
        
    }
    @IBAction func leaveroomButton(_ sender: Any) {
        menuView.isHidden = true
        let vc = LeaveRoomViewController()
        vc.modalPresentationStyle = .overCurrentContext
        vc.modalTransitionStyle = .crossDissolve
        
        present(vc, animated: false)
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
        
        recordInit()
        let date = Date(timeIntervalSince1970: TimeInterval(Int(startTime) ?? 0).rounded())
        let elapsedTimeSeconds = Int(Date().timeIntervalSince(date))
        let hours = elapsedTimeSeconds / 3600
        let minutes = (elapsedTimeSeconds % 3600) / 60
        timeLabel.text = String(format: "%02d시간 %02d분", hours, minutes)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
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
            chattingFieldConstraint.constant = 112
        }
        else {
            sendButton.isEnabled = true
            photoButton.isHidden = true
            recordButton.isHidden = true
            chattingFieldConstraint.constant = 18
        }
    }
}

//MARK: Audio
extension ChattingViewController: AVAudioRecorderDelegate, AVAudioPlayerDelegate {
    func recordInit() {
        let directoryURL = FileManager.default.urls(for: FileManager.SearchPathDirectory.documentDirectory, in: FileManager.SearchPathDomainMask.userDomainMask).first
        let audioFileName = UUID().uuidString + ".m4a"
        let audioFileURL = directoryURL?.appendingPathComponent(audioFileName)
        
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setCategory(.playAndRecord, options: [.allowAirPlay, .allowBluetooth, .defaultToSpeaker])
        } catch _ {
            
        }
        
        let recorderSetting = [AVFormatIDKey: NSNumber(value: kAudioFormatMPEG4AAC as UInt32), AVSampleRateKey: 44100.0, AVNumberOfChannelsKey: 2]
        audioRecorder = try? AVAudioRecorder(url: audioFileURL!, settings: recorderSetting)
        audioRecorder.delegate = self
        audioRecorder.isMeteringEnabled = true
        audioRecorder?.prepareToRecord()
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
    
    func record() {
        pencil.removeAllPoints()
        waveLayer.removeFromSuperlayer()
        writeWaves(0, false)
        
        requestMicrophoneAccess { [weak self] allowed in
            if allowed {
                if let player = self!.audioPlayer {
                    if player.isPlaying {
                        player.stop()
                    }
                }
                
                var time = 0
                self?.recordTimer = Timer.scheduledTimer(withTimeInterval: 0.2, repeats: true) { (timer) in
                    
                    self?.audioRecorder.updateMeters()
                    self?.writeWaves((self?.audioRecorder.averagePower(forChannel: 0))!, true)
                    
                    let bottomOffset = CGPoint(x: (self?.waveViewWidth.constant)!, y: 0)
                    self!.recordScrollView.setContentOffset(bottomOffset, animated: false)
                    time += 1
                    let minute = time / (5 * 60)
                    let second = time % (5 * 60) / 5
                    
                    self?.recoredTimeLabel.text = String(format: "%02d:%02d", minute, second)
                }
                
                self!.audioRecorder.record()
            } else {
                //self?.showSettingsAlert()
            }
        }
    }
    
    func stopRecord() {
        audioRecorder.stop()
        print(audioRecorder.url)
        uploadAudio(audio: audioRecorder.url)
    }
    
    func uploadAudio(audio: URL) {
        let audioData = (try? Data(contentsOf: audio))!
        
        let time = Int64(Date().timeIntervalSince1970 * 1000)
        let filePath = "audio/\(time)\(UserDefaults.standard.string(forKey: "UserID") ?? "")"
        let metaData = StorageMetadata()
        metaData.contentType = "audio/m4a"
        do {
            let audioData = try Data(contentsOf: audio)
            
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
        catch {
            debugPrint(error.localizedDescription)
        }
        
    }
    
    func writeWaves(_ input: Float, _ bool: Bool) {
        if !bool {
            start = firstPoint
            if recordTimer != nil {
                recordTimer.invalidate()
            }
            return
        }
        else {
            if input < -55 {
                traitLength = 0.2
            } else if input < -40 && input > -55 {
                traitLength = (CGFloat(input) + 56) / 3
            } else if input < -20 && input > -40 {
                traitLength = (CGFloat(input) + 41) / 2
            } else if input < -10 && input > -20 {
                traitLength = (CGFloat(input) + 21) * 5
            } else {
                traitLength = (CGFloat(input) + 20) * 4
            }
            
            waveViewWidth.constant = start.x
            
            pencil.lineWidth = jump * 2
            pencil.lineCapStyle = .round
            
            pencil.move(to: start)
            pencil.addLine(to: CGPoint(x: start.x, y: start.y + traitLength))
            
            pencil.move(to: start)
            pencil.addLine(to: CGPoint(x: start.x, y: start.y - traitLength))
            
            waveLayer.strokeColor = UIColor.white.cgColor
            
            waveLayer.path = pencil.cgPath
            waveLayer.fillColor = UIColor.clear.cgColor
            
            waveLayer.lineWidth = jump * 2
            waveLayer.lineCap = .round
            
            waveView.layer.addSublayer(waveLayer)
            waveLayer.contentsCenter = waveView.frame
            waveView.setNeedsDisplay()
            
            start = CGPoint(x: start.x + jump * 2 + 2, y: start.y)
            
        }
    }
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        if flag {
            audioPlayingIndex = -1
            chatTableView.reloadData()
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
            chattingFieldConstraint.constant = 112
        }
        else {
            sendButton.isEnabled = true
            photoButton.isHidden = true
            recordButton.isHidden = true
            chattingFieldConstraint.constant = 18
        }
        
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if chattingTextField.text == "" {
            sendButton.isEnabled = false
            photoButton.isHidden = false
            recordButton.isHidden = false
            chattingFieldConstraint.constant = 112
        }
        else {
            sendButton.isEnabled = true
            photoButton.isHidden = true
            recordButton.isHidden = true
            chattingFieldConstraint.constant = 18
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
            
            if message.sender == UserDefaults.standard.string(forKey: "UserNickname")! {
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
            
            if message.sender == UserDefaults.standard.string(forKey: "UserNickname")! {
                let cell = tableView.dequeueReusableCell(withIdentifier: "ImageSendingTableViewCell", for: indexPath) as! ImageSendingTableViewCell
                cell.selectionStyle = .none
        
                cell.sendingImageView.sd_setImage(with: image)
                
                cell.sendingTime.text = message.time
                cell.layoutIfNeeded()
                
                chatTableView.reloadRows(at: [indexPath], with: .automatic)
                return cell
            }
            else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "ImageReceivingTableViewCell", for: indexPath) as! ImageReceivingTableViewCell
                cell.selectionStyle = .none
                
                cell.receivingImageView.sd_setImage(with: image)
                
                cell.receivingTime.text = message.time
                cell.layoutIfNeeded()
                chatTableView.reloadRows(at: [indexPath], with: .automatic)
                return cell
            }
        }
        else {
            if message.sender == UserDefaults.standard.string(forKey: "UserNickname")! {
                let cell = tableView.dequeueReusableCell(withIdentifier: "AudioSendingTableViewCell", for: indexPath) as! AudioSendingTableViewCell
                cell.playStopButton.content = String(message.body)
                cell.playStopButton.addTarget(self, action: #selector(playStop(_:)), for: .touchUpInside)
                cell.playStopButton.tag = indexPath.row
                cell.audioSlider
                
                if indexPath.row != audioPlayingIndex {
                    cell.playStopButton.isSelected = false
                }
                else {
                    cell.playStopButton.isSelected = true
                }
                
                return cell
            }
            else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "AudioReceivingTableViewCell", for: indexPath) as! AudioReceivingTableViewCell
                cell.playStopButton.content = String(message.body)
                cell.playStopButton.addTarget(self, action: #selector(playStop(_:)), for: .touchUpInside)
                cell.playStopButton.tag = indexPath.row
                
                if indexPath.row != audioPlayingIndex {
                    cell.playStopButton.isSelected = false
                } else {
                    cell.playStopButton.isSelected = true
                }
                
                return cell
            }
        }
    }
    
    @objc func playStop(_ sender: PlayStopButton) {
        
        let cell = chatTableView.cellForRow(at: [0, sender.tag])
        
        if  sender.isSelected == true {
            sender.isSelected = false
            
            audioPlayer.stop()
            audioPlayingIndex = -1
        }
        else {
            sender.isSelected = true
            self.audioPlayingIndex = sender.tag
           
            let audioRef = storageRef.child("audio/\(sender.content)")
            audioRef.downloadURL { url, error in
                if let error = error {
                    print(error.localizedDescription)
                } else {
                    do{
                        let soundData = try Data(contentsOf: url!)
                        self.audioPlayer = try AVAudioPlayer(data: soundData)
                        self.audioPlayer.prepareToPlay()
                        self.audioPlayer.delegate = self
                        self.audioPlayer.play()
                        
                    } catch {
                        print("something went wrong")
                    }
                }
            }
        }
        
        chatTableView.reloadData()
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
                    "senderUid": UserDefaults.standard.string(forKey: "UserID")!,
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
            "senderUid": UserDefaults.standard.string(forKey: "UserID")!,
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
                                    if self.messages.count != 0 {
                                        self.chatTableView.scrollToRow(at: [0, self.messages.count - 1], at: .bottom, animated: false)
                                    }
                                    
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
        chatTableView.contentInset.bottom = keyboardHeight - view.safeAreaInsets.bottom
        if messages.count > 0 {
            chatTableView.scrollToRow(at: [0, messages.count - 1], at: .bottom, animated: false)
        }
        
        self.view.layoutSubviews()
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        chatTableView.contentInset.bottom = 0
        toolbarBottomConstraint.constant = 0
        chatTableView.frame.origin.y = 0
        self.view.layoutSubviews()
        
    }
    
    
    func removeKeyboardNotification() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)

    }
}
