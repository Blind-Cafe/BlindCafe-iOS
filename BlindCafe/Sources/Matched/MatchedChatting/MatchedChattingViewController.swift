//
//  MatchedChattingViewController.swift
//  BlindCafe
//
//  Created by 권하은 on 2021/11/25.
//

import UIKit
import FirebaseFirestore
import Photos
import Alamofire
import FirebaseStorageUI
import Firebase
import SDWebImage
import AVFoundation

class MatchedChattingViewController: BaseViewController {

    var delegate: MyTable?
    
    @IBOutlet weak var topView: UIView!
    
    var startTime: String = ""
    @IBOutlet weak var timeLabel: UILabel!
    
    var matchingId: Int = 0
    var partnerName: String = ""
    
    var keyboardFrameHeight: CGFloat = 0
    
    let db = Firestore.firestore()
    
    var messages: [Message] = []
    
    
    let storageRef = Storage.storage().reference()
    let storage = Storage.storage()
    
    var audioRecorder: AVAudioRecorder!
    var audioPlayer: AVAudioPlayer?
    
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
    var audioTimer = Timer()
    deinit {
        audioTimer.invalidate()
    }
    
    //Top
    @IBOutlet weak var menuView: UIView!
    @IBOutlet weak var recordView: UIView!
    
    @IBAction func reportButton(_ sender: Any) {
        menuView.isHidden = true
        let vc = ReportViewController()
        vc.modalPresentationStyle = .overCurrentContext
        vc.modalTransitionStyle = .crossDissolve
        vc.matchingId = matchingId
        present(vc, animated: false)
        
    }
    @IBAction func leaveroomButton(_ sender: Any) {
        menuView.isHidden = true
        let vc = LeaveRoomViewController()
        vc.modalPresentationStyle = .overCurrentContext
        vc.modalTransitionStyle = .crossDissolve
        vc.matchingId = matchingId
        vc.partnerName = partnerName
        
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
        PHPhotoLibrary.requestAuthorization { (status) in
            switch status {
            case .authorized, .limited:
                let fetchOptions = PHFetchOptions()
                fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
                fetchOptions.predicate = NSPredicate(format: "mediaType = %d", PHAssetMediaType.image.rawValue)
                allPhotos = PHAsset.fetchAssets(with: .image, options: fetchOptions)
                photocount = allPhotos?.count ?? 0
                
                DispatchQueue.main.async {
                    let vc = PhotoViewController()
                    vc.modalPresentationStyle = .pageSheet
                    vc.matchingId = self.matchingId
                    self.present(vc, animated: true)
                }
                    
            case .denied, .restricted:
                DispatchQueue.main.async {
                    self.presentAlert(message: "설정에서 사진 권한을 허용해주세요")
                }
            case .notDetermined:
                DispatchQueue.main.async {
                    self.presentAlert(message: "설정에서 사진 권한을 허용해주세요")
                }
            @unknown default:
                print("error")
            }
        }
    }
    @IBOutlet weak var recordButton: UIButton!

    @IBOutlet weak var chattingField: UIImageView!
    @IBOutlet weak var chattingTextField: UITextView!
    @IBOutlet weak var sendButton: UIButton!
   
    @IBOutlet weak var chattingFieldConstraint: NSLayoutConstraint!
    @IBOutlet weak var tableViewBottom: NSLayoutConstraint!
    
    var drinkName = ""
    var isFirst = true
    var common = ""
    
    @IBAction func sendMessage(_ sender: Any) {
        if chattingTextField.text != nil && !chattingTextField.text!.isEmpty {
            let input = PostChattingInput(type: 1, contents: chattingTextField.text)
            MatchedSendDataManager().postChatting(input, id: matchingId, viewController: self)
        }
        self.chattingTextField.text = ""
        sendButton.isEnabled = false
        photoButton.isHidden = false
        recordButton.isHidden = false
        chattingFieldConstraint.constant = 112
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        topView.backgroundColor = .lightchat
        
        self.playing = 0
        recordView.isHidden = true
        
        view.backgroundColor = .lightView
        
        navigationController?.navigationBar.isHidden = false
        menuView.isHidden = true

        self.toolbarBottomConstraintInitialValue = toolbarBottomConstraint?.constant
        enableKeyboardHideOnTap()
        
        chatTableView.register(UINib(nibName: "TextTableViewCell", bundle: nil), forCellReuseIdentifier: "TextTableViewCell")
        chatTableView.register(UINib(nibName: "ImageSendingTableViewCell", bundle: nil), forCellReuseIdentifier: "ImageSendingTableViewCell")
        chatTableView.register(UINib(nibName: "ImageReceivingTableViewCell", bundle: nil), forCellReuseIdentifier: "ImageReceivingTableViewCell")
        chatTableView.register(UINib(nibName: "AudioSendingTableViewCell", bundle: nil), forCellReuseIdentifier: "AudioSendingTableViewCell")
        chatTableView.register(UINib(nibName: "AudioReceivingTableViewCell", bundle: nil), forCellReuseIdentifier: "AudioReceivingTableViewCell")
        chatTableView.register(UINib(nibName: "DescriptionTableViewCell", bundle: nil), forCellReuseIdentifier: "DescriptionTableViewCell")
        chatTableView.register(UINib(nibName: "TextTopicTableViewCell", bundle: nil), forCellReuseIdentifier: "TextTopicTableViewCell")
        chatTableView.register(UINib(nibName: "ImageTopicTableViewCell", bundle: nil), forCellReuseIdentifier: "ImageTopicTableViewCell")
        chatTableView.register(UINib(nibName: "AudioTopicTableViewCell", bundle: nil), forCellReuseIdentifier: "AudioTopicTableViewCell")
        chatTableView.register(UINib(nibName: "Type8TableViewCell", bundle: nil), forCellReuseIdentifier: "Type8TableViewCell")
        
        chatTableView.delegate = self
        chatTableView.dataSource = self
        chatTableView.separatorStyle = .none
        chatTableView.backgroundColor = .lightchat
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
        
        let date = Date(timeIntervalSince1970: TimeInterval(Int(startTime) ?? 0).rounded())
        let elapsedTimeSeconds = Int(Date().timeIntervalSince(date))
        let hours = elapsedTimeSeconds / 3600
        let minutes = (elapsedTimeSeconds % 3600) / 60
        timeLabel.text = String(format: "%02d시간 %02d분", hours, minutes)
        
    }

    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        loadMessages()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        removeKeyboardNotification()
        audioPlayer?.stop()
        
        showIndicator()
        let input = RequestMatchingInput()
        MatchedLogDataManager().log(input, id: matchingId, viewController: self)
    }
    
    @objc func buttonDown() {
        requestMicrophoneAccess { [weak self] allowed in
            if allowed {
                self?.recordView.isHidden = false
                self?.record()
            } else {
                self?.presentAlert(message: "설정에서 마이크 권한을 허용해주세요")
            }
        }
    }
    
    @objc func buttonUp() {
        requestMicrophoneAccess { [weak self] allowed in
            if allowed {
                self?.recordView.isHidden = true
                self?.stopRecord()
            }
        }
    }
    
    //MARK: NavigationBar
    func navigationbarCustom(title: String) {
        navigationController?.navigationBar.isHidden = false
        navigationController?.navigationBar.tintColor = .veryLightPink
        navigationController?.navigationBar.barTintColor = .lightchat
        
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
        
        let menuButton: UIButton = UIButton()
        menuButton.setImage(UIImage(named: "menubutton"), for: .normal)
        menuButton.addTarget(self, action: #selector(menuButtonAction), for: .touchUpInside)
        
        let stackView = UIStackView.init(arrangedSubviews: [menuButton])
        stackView.distribution = .equalSpacing
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.spacing = 0
        let rightBarButton = UIBarButtonItem(customView: stackView)
        
        self.navigationItem.setLeftBarButtonItems([addBackButton, addNameLabel], animated: false)
        self.navigationItem.rightBarButtonItem = rightBarButton
    }
    
    @objc func popToHome(){
        delegate?.getTable()
        navigationController?.popToRootViewController(animated: true)
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
extension MatchedChattingViewController : AVAudioRecorderDelegate, AVAudioPlayerDelegate {
    func recordInit() {
        let directoryURL = FileManager.default.urls(for: FileManager.SearchPathDirectory.documentDirectory, in: FileManager.SearchPathDomainMask.userDomainMask).first
        let audioFileName = UUID().uuidString + ".m4a"
        let audioFileURL = directoryURL?.appendingPathComponent(audioFileName)
        
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setCategory(.playAndRecord, options: [.mixWithOthers, .allowAirPlay, .allowBluetooth, .defaultToSpeaker])
            try audioSession.setActive(false)
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
        recordInit()
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
            _ = uploadTask.observe(.success) { snapshot in
                let input = PostChattingInput(type: 3, contents: "\(time)\(UserDefaults.standard.string(forKey: "UserID") ?? "")")
                MatchedSendDataManager().postChatting(input, id: self.matchingId, viewController: self)
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
extension MatchedChattingViewController: UITextViewDelegate {
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
extension MatchedChattingViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var isAfter = true
        if messages.count > 2 && indexPath.row > 0 {
            if messages[indexPath.row - 1].senderId == messages[indexPath.row].senderId {
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
            cell.backgroundColor = .lightchat
            if message.senderId == UserDefaults.standard.string(forKey: "UserID")! {
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
            
            if message.senderId == UserDefaults.standard.string(forKey: "UserID")! {
                let cell = tableView.dequeueReusableCell(withIdentifier: "ImageSendingTableViewCell", for: indexPath) as! ImageSendingTableViewCell
                cell.backgroundColor = .lightchat
                cell.selectionStyle = .none
        
                cell.sendingImageView.sd_setImage(with: image)
                
                cell.sendingTime.text = message.time
                cell.layoutIfNeeded()
                
                chatTableView.reloadRows(at: [indexPath], with: .automatic)
                return cell
            }
            else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "ImageReceivingTableViewCell", for: indexPath) as! ImageReceivingTableViewCell
                cell.backgroundColor = .lightchat
                cell.selectionStyle = .none
                
                cell.receivingImageView.sd_setImage(with: image)
                
                cell.receivingTime.text = message.time
                cell.layoutIfNeeded()
                chatTableView.reloadRows(at: [indexPath], with: .automatic)
                return cell
            }
        }
        else if message.type == 3 {
            if message.senderId == UserDefaults.standard.string(forKey: "UserID")! {
                let cell = tableView.dequeueReusableCell(withIdentifier: "AudioSendingTableViewCell", for: indexPath) as! AudioSendingTableViewCell
                cell.backgroundColor = .lightchat
                cell.playStopButton.content = String(message.body)
                cell.audioSlider.tag = indexPath.row
                cell.playStopButton.tag = indexPath.row
                cell.playStopButton.addTarget(self, action: #selector(playStop(_:)), for: .touchUpInside)
                //cell.audioSlider.addTarget(self, action: #selector(sliderAction(_:)), for: .valueChanged)
                
                if indexPath.row != audioPlayingIndex {
                    cell.playStopButton.isSelected = false
                    cell.audioSlider.value = 0
                    cell.audioTimeLabel.text = "00:00"
                }
                else {
                    cell.playStopButton.isSelected = true
                    cell.audioSlider.maximumValue = Float(Int(self.audioPlayer?.duration ?? 0))
                    cell.audioSlider.minimumValue = 0.0
                    cell.audioSlider.value = Float(playing)
                    let minutes = playing / 60
                    let seconds = playing % 60
                    cell.audioTimeLabel.text = String(format: "%02d:%02d", minutes, seconds)
                }
                
                return cell
            }
            else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "AudioReceivingTableViewCell", for: indexPath) as! AudioReceivingTableViewCell
                cell.backgroundColor = .lightchat
                cell.playStopButton.content = String(message.body)
                cell.playStopButton.addTarget(self, action: #selector(playStop(_:)), for: .touchUpInside)
                cell.playStopButton.tag = indexPath.row
                cell.audioSlider.tag = indexPath.row
                
                if indexPath.row != audioPlayingIndex {
                    cell.playStopButton.isSelected = false
                    cell.audioSlider.value = 0
                    cell.audioTimeLabel.text = "00:00"
                } else {
                    cell.playStopButton.isSelected = true
                    if audioPlayer != nil {
                        cell.audioSlider.maximumValue = Float(Int(self.audioPlayer!.duration))
                    }
                    cell.audioSlider.minimumValue = 0.0
                    cell.audioSlider.value = Float(playing)
                    let minutes = playing / 60
                    let seconds = playing % 60
                    cell.audioTimeLabel.text = String(format: "%02d:%02d", minutes, seconds)
                }
                
                return cell
            }
        }
        else if message.type == 4 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "TextTopicTableViewCell", for: indexPath) as! TextTopicTableViewCell
            cell.backgroundColor = .lightchat
            cell.textTopicLabel.text = message.body
            
            return cell
        } else if message.type == 5 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ImageTopicTableViewCell", for: indexPath) as! ImageTopicTableViewCell
            cell.backgroundColor = .lightchat
            let url = URL(string: message.body)
            let data = try? Data(contentsOf: url!)
            cell.imageTopicImageView.image = UIImage(data: data ?? Data())
            
            return cell
        } else if message.type == 6 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "AudioTopicTableViewCell", for: indexPath) as! AudioTopicTableViewCell
            cell.backgroundColor = .lightchat
            cell.playStopButton.tag = indexPath.row
            cell.playStopButton.addTarget(self, action: #selector(topicPlayStop(_:)), for: .touchUpInside)
            
            cell.audioSlider.tag = indexPath.row
            
            if indexPath.row != audioPlayingIndex {
                cell.playStopButton.isSelected = false
                cell.audioSlider.value = 0
                cell.audioTimeLabel.text = "00:00"
            } else {
                cell.playStopButton.isSelected = true
                if audioPlayer != nil {
                    cell.audioSlider.maximumValue = Float(Int(self.audioPlayer!.duration))
                }
                cell.audioSlider.minimumValue = 0.0
                cell.audioSlider.value = Float(playing)
                let minutes = playing / 60
                let seconds = playing % 60
                cell.audioTimeLabel.text = String(format: "%02d:%02d", minutes, seconds)
            }
            
            return cell
        }
        else if message.type == 7 || message.type == 9 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "DescriptionTableViewCell", for: indexPath) as! DescriptionTableViewCell
            cell.backgroundColor = .lightchat
            if message.body.contains("<") {
                let strArr = message.body.components(separatedBy: CharacterSet(charactersIn: "<>"))
                
                let str = strArr[0] + strArr[1] + strArr[2]
                let attributedstr = NSMutableAttributedString(string: str)
                attributedstr.addAttribute(.foregroundColor, value: UIColor(hex: 0xb1d0b7), range: (str as NSString).range(of: strArr[1]))
                
                cell.descriptionLabel.attributedText = attributedstr
            } else {
                cell.descriptionLabel.text = message.body
            }
            return cell
        } else if message.type == 8 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "Type8TableViewCell", for: indexPath) as! Type8TableViewCell
            cell.badgeLabel.text = "프로필 교환에 성공하셨으니 \(message.body) 뱃지를 획득하셨습니다.\n홈에서 새로운 매칭을 하실 수 있어요!"
            cell.backgroundColor = .lightchat
            return cell
        } else {
            return UITableViewCell()
        }
    }
    
    @objc func topicPlayStop(_ sender: UIButton){
        if  sender.isSelected == true {
            sender.isSelected = false
            
            if audioPlayer != nil {
                audioPlayer?.stop()
                audioPlayingIndex = -1
                playing = 0
            }
            
            chatTableView.reloadData()
        }
        else {
            sender.isSelected = true
            self.audioPlayingIndex = sender.tag
            
            do{
                let url = URL(string: messages[sender.tag].body)!
                let soundData = try Data(contentsOf: url)
                self.audioPlayer = try AVAudioPlayer(data: soundData)
                self.audioPlayer?.prepareToPlay()
                self.audioPlayer?.delegate = self
                self.audioPlayer?.play()
                
                self.chatTableView.reloadData()
                
                self.audioPlayTimer(tag: sender.tag, current: 0)
            } catch {
                print("something went wrong")
            }
        }
    }
    
    @objc func playStop(_ sender: PlayStopButton) {
        
        if  sender.isSelected == true {
            sender.isSelected = false
            
            if audioPlayer != nil {
                audioPlayer?.stop()
                audioPlayingIndex = -1
                playing = 0
            }
            
            chatTableView.reloadData()
        }
        else {
            sender.isSelected = true
            self.audioPlayingIndex = sender.tag
            
            let audioRef = storageRef.child("audio/\(sender.content)")
            print(audioRef)
            audioRef.downloadURL { url, error in
                if let error = error {
                    print(error.localizedDescription)
                } else {
                    do{
                        let soundData = try Data(contentsOf: url!)
                        self.audioPlayer = try AVAudioPlayer(data: soundData)
                        self.audioPlayer?.prepareToPlay()
                        self.audioPlayer?.delegate = self
                        self.audioPlayer?.play()
                        
                        self.chatTableView.reloadData()
                        
                        self.audioPlayTimer(tag: sender.tag, current: 0)
                    } catch {
                        print("something went wrong")
                    }
                }
            }
        }
    }
    func audioPlayTimer(tag: Int, current: Int) {
        //self.playing = current
        audioTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { (timer) in
            if self.playing >= Int(self.audioPlayer?.duration ?? 0) {
                timer.invalidate()
                self.playing = 0
            }
            else {
                self.playing += 1
                
                let indexPath: IndexPath = [0, tag]
                self.chatTableView.reloadRows(at: [indexPath], with: .none)
            }
            
        }
    }
}

//MARK: Firestore
extension MatchedChattingViewController {
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
                            if let sender = data["senderUid"] as? String, let body = data["contents"] as? String, let timestamp = data["timestamp"] as? Timestamp, let type = data["type"] as? Int {
                                let time = self.timeFormatter(timestamp: timestamp)
                                if !(type == 8 && sender != UserDefaults.standard.string(forKey: "UserID")! ){
                                    self.messages.append(Message(senderId: sender, body: body, time: time, type: type))
                                }
                                
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
extension MatchedChattingViewController {
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

extension MatchedChattingViewController {
    func chatLog() {
        dismissIndicator()
        print("log")
    }
    
    func send() {
        dismissIndicator()
    }
    
    func failedToRequest(message: String) {
        dismissIndicator()
        presentAlert(message: message)
    }
}
