//
//  ChattingViewController.swift
//  BlindCafe
//
//  Created by 권하은 on 2021/11/03.
//

import UIKit
import FirebaseFirestore
import PhotosUI

struct Message {
    let sender: String
    let body: String
    let time: String
}

class ChattingViewController: BaseViewController {
    
    let db = Firestore.firestore()
    
    var messages: [Message] = []

    //Top
    @IBAction func backButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    @IBOutlet weak var partnerNickname: UILabel!
    @IBAction func bellButton(_ sender: Any) {
    }
    @IBAction func menuButton(_ sender: Any) {
        if menuView.isHidden {
            menuView.isHidden = false
        }
        else {
            menuView.isHidden = true
        }
    }
    @IBOutlet weak var menuView: UIView!
    
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
        askPermissionPhoto()
    }
    @IBOutlet weak var recordButton: UIButton!
    @IBAction func recordButton(_ sender: Any) {
    }
    @IBOutlet weak var chattingField: UIImageView!
    @IBOutlet weak var chattingTextField: UITextField!
    @IBOutlet weak var sendButton: UIButton!
    @IBAction func sendButton(_ sender: Any) {
    }
    
    @IBOutlet weak var chattingFieldConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        menuView.isHidden = true

        self.toolbarBottomConstraintInitialValue = toolbarBottomConstraint?.constant
        enableKeyboardHideOnTap()
        
        chatTableView.register(UINib(nibName: "SendingTableViewCell", bundle: nil), forCellReuseIdentifier: "SendingTableViewCell")
        chatTableView.register(UINib(nibName: "ReceivingTableViewCell", bundle: nil), forCellReuseIdentifier: "ReceivingTableViewCell")
        
        chatTableView.delegate = self
        chatTableView.dataSource = self
        chatTableView.separatorStyle = .none
        chatTableView.backgroundColor = .mainBlack
        
        self.chattingTextField.addTarget(self, action: #selector(textFieldDidChange(_sender:)), for: .editingChanged)
        
        if chattingTextField.text == "" {
            sendButton.isEnabled = false
        }
        
        chattingTextField.textColor = .white
        
        loadMessages()
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

//MARK: 갤러리
extension ChattingViewController: PHPickerViewControllerDelegate{
    
    func askPermissionPhoto() {
        PHPhotoLibrary.requestAuthorization({ (status) in
            if status == PHAuthorizationStatus.authorized {
                self.showPhotoLibrary()
            } else {
                if let url = URL(string: UIApplication.openSettingsURLString) {
                    if UIApplication.shared.canOpenURL(url) {
                        UIApplication.shared.open(url, options: [:], completionHandler: nil)
                    }
                }
            }
        })
    }
    
    func showPhotoLibrary() {
        var config = PHPickerConfiguration()
        config.selectionLimit = 5
        config.filter = .images
        
        let picker = PHPickerViewController(configuration: config)
        picker.delegate = self
        
        present(picker, animated: true, completion: nil)
    }
    
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        if let itemProvider = results.first?.itemProvider, itemProvider.canLoadObject(ofClass: UIImage.self) {
            itemProvider.loadObject(ofClass: UIImage.self) { [weak self] image, error in
                DispatchQueue.main.async {
                    guard let self = self else { return }
                    if let image = image as? UIImage {
                        picker.dismiss(animated: false, completion: nil)
                    }
                }
            }
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
        if indexPath.row > 0 {
            if messages[indexPath.row - 1].sender == messages[indexPath.row].sender {
                isAfter = true
            }
            else {
                isAfter = false
            }
        }
        
        
        let message = messages[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "SendingTableViewCell", for: indexPath) as! SendingTableViewCell
        let cell1 = tableView.dequeueReusableCell(withIdentifier: "ReceivingTableViewCell", for: indexPath) as! ReceivingTableViewCell
        
        if message.sender == "." {
            cell.selectionStyle = .none
            cell.message.text = message.body
            cell.timeLabel.text = message.time
            
            if isAfter {
                cell.topConstraint.constant = 4
            }
            else {
                cell.topConstraint.constant = 12
            }
            
            return cell
        }
        else {
            cell1.selectionStyle = .none
            cell1.message.text = message.body
            cell1.timeLabel.text = message.time
            
            if isAfter {
                cell1.topConstraint.constant = 4
            }
            else {
                cell1.topConstraint.constant = 12
            }
            
            return cell1
        }
    }
    
}

//MARK: Firestore 채팅
extension ChattingViewController {
    @IBAction func sendMessage(_ sender: Any) {
        if let messageBody = chattingTextField.text {
            db.collection("Rooms/-/Messages").addDocument(data: [
                "contents": messageBody,
                "senderName": ".",
                "senderUid": ".",
                "timestamp": Date(),
                "type": 0
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
        
        print(Date())
    }
    
    private func loadMessages() {
        db.collection("Rooms/-/Messages")
            .order(by: "timestamp")
            .addSnapshotListener { (querySnapshot, error) in
                self.messages = []
                
                if let e = error {
                    print(e.localizedDescription)
                } else {
                    if let snapshotDocuments = querySnapshot?.documents {
                        snapshotDocuments.forEach { (doc) in
                            let data = doc.data()
                            if let sender = data["senderName"] as? String, let body = data["contents"] as? String, let timestamp = data["timestamp"] as? Timestamp {
                                let time = self.timeFormatter(timestamp: timestamp)
                                self.messages.append(Message(sender: sender, body: body, time: time))
                                
                                DispatchQueue.main.async {
                                    self.chatTableView.reloadData()
                                    self.chatTableView.scrollToRow(at: IndexPath(row: self.messages.count - 1, section: 0), at: .top, animated: false)
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
        dateFormatter.dateFormat = "a HH:mm"
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
//        tap.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tap)
    }
    
    @objc func dismissAll() {
        self.view.endEditing(false)
        self.menuView.isHidden = true
    }

    @objc func keyboardWillShow(notification: NSNotification) {

        let info = notification.userInfo!

        let keyboardFrame: CGRect = (info[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue

        if let durationNumber = notification.userInfo![UIResponder.keyboardFrameEndUserInfoKey] as? NSNumber, let curveValue = info[UIResponder.keyboardAnimationCurveUserInfoKey] as? NSNumber {
            let duration = durationNumber.doubleValue
            let keyboardCurve = curveValue.intValue
            let curve: UIView.AnimationCurve = UIView.AnimationCurve(rawValue: keyboardCurve) ?? .linear
            let options = UIView.AnimationOptions(rawValue: UInt(curve.rawValue << 16))
            
            UIView.animate(withDuration: duration, delay: 0, options: options, animations: {
                self.view.layoutIfNeeded()
            }, completion: nil)
        }
        else {
            self.toolbarBottomConstraint?.constant = keyboardFrame.size.height - 35
            self.view.layoutIfNeeded()
        }
        
        textFieldDidChange(_sender: chattingTextField)
    }

    @objc func keyboardWillHide(notification: NSNotification) {

        let info = notification.userInfo!

        if let durationNumber = notification.userInfo![UIResponder.keyboardFrameEndUserInfoKey] as? NSNumber, let curveValue = info[UIResponder.keyboardAnimationCurveUserInfoKey] as? NSNumber {
            let duration = durationNumber.doubleValue
            let keyboardCurve = curveValue.intValue
            let curve: UIView.AnimationCurve = UIView.AnimationCurve(rawValue: keyboardCurve) ?? .linear
            let options = UIView.AnimationOptions(rawValue: UInt(curve.rawValue << 16))
            
            UIView.animate(withDuration: duration, delay: 0, options: options, animations: {
                self.toolbarBottomConstraint.constant = 8
                self.view.layoutIfNeeded()
            }, completion: nil)
        }
        else {
            self.toolbarBottomConstraint.constant = 8
            self.view.layoutIfNeeded()
        }
        
        textFieldDidChange(_sender: chattingTextField)
    }
}
