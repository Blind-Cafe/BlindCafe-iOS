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

struct Message {
    let sender: String
    let body: String
    let time: String
    let type: Int
}

class ChattingViewController: BaseViewController {
    
    let db = Firestore.firestore()
    
    var messages: [Message] = []
    
    let storageRef = Storage.storage().reference()

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
        let vc = PhotoViewController()
        vc.modalPresentationStyle = .pageSheet
        present(vc, animated: true)
    }
    @IBOutlet weak var recordButton: UIButton!
    @IBAction func recordButton(_ sender: Any) {
    }
    @IBOutlet weak var chattingField: UIImageView!
    @IBOutlet weak var chattingTextField: UITextView!
    @IBOutlet weak var sendButton: UIButton!
   
    
    @IBOutlet weak var chattingFieldConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .black2
        
        navigationController?.navigationBar.isHidden = false
        menuView.isHidden = true

        self.toolbarBottomConstraintInitialValue = toolbarBottomConstraint?.constant
        enableKeyboardHideOnTap()
        
        chatTableView.register(UINib(nibName: "TextTableViewCell", bundle: nil), forCellReuseIdentifier: "TextTableViewCell")
        chatTableView.register(UINib(nibName: "ImageTableViewCell", bundle: nil), forCellReuseIdentifier: "ImageTableViewCell")
        
        chatTableView.delegate = self
        chatTableView.dataSource = self
        chatTableView.separatorStyle = .none
        chatTableView.backgroundColor = .mainBlack
        
        chattingTextField.delegate = self
        
        if chattingTextField.text == "" {
            sendButton.isEnabled = false
        }
        
        chattingTextField.textColor = .white
        
        loadMessages()
        navigationbarCustom(title: "당")
    }
    
    func navigationbarCustom(title: String) {
        navigationController?.navigationBar.isHidden = false
        navigationController?.navigationBar.tintColor = .veryLightPink
        navigationController?.navigationBar.barTintColor = .mainBlack
        
        let backButton: UIButton = UIButton()
        backButton.setImage(UIImage(named: "backbutton"), for: .normal)
        backButton.addTarget(self, action: #selector(popToVC), for: .touchUpInside)
        backButton.frame = CGRect(x: 18, y: 0, width: 44, height: 44)
        let addBackButton = UIBarButtonItem(customView: backButton)
        
        self.navigationItem.setLeftBarButtonItems([addBackButton], animated: false)
    }
    
    @objc func popToVC() {
        navigationController?.popViewController(animated: true)
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
        if indexPath.row > 0 {
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
            
            if message.sender == "." {
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
            let cell = tableView.dequeueReusableCell(withIdentifier: "ImageTableViewCell", for: indexPath) as! ImageTableViewCell
            cell.selectionStyle = .none
            
            let image = Storage.storage().reference(forURL: "gs://blind-cafe.appspot.com/image/\(message.body)")
            
            if message.sender == "." {
                cell.receivingImageView.isHidden = true
                cell.receivingTime.isHidden = true
                cell.sendingImageView.isHidden = false
                cell.sendingTime.isHidden = false
                
                cell.sendingImageView.sd_setImage(with: image)
        
                cell.sendingTime.text = message.time
            }
            else {
                cell.sendingImageView.isHidden = true
                cell.sendingTime.isHidden = true
                cell.receivingImageView.isHidden = false
                cell.receivingTime.isHidden = false
                
                cell.receivingImageView.sd_setImage(with: image)
                
                cell.receivingTime.text = message.time
            }
            return cell
        }
        else {
            return UITableViewCell()
        }
    }
    
}

//MARK: Firestore 채팅
extension ChattingViewController {
    @IBAction func sendMessage(_ sender: Any) {
        if chattingTextField.text != nil && !chattingTextField.text!.isEmpty {
            if let messageBody = chattingTextField.text {
                db.collection("Rooms/-/Messages").addDocument(data: [
                    "contents": messageBody,
                    "senderName": ".",
                    "senderUid": ".",
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
    }
    
    func send(contents: String, type: Int) {
        db.collection("Rooms/-/Messages").addDocument(data: [
            "contents": contents,
            "senderName": ".",
            "senderUid": ".",
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
                            if let sender = data["senderName"] as? String, let body = data["contents"] as? String, let timestamp = data["timestamp"] as? Timestamp, let type = data["type"] as? Int {
                                let time = self.timeFormatter(timestamp: timestamp)
                                self.messages.append(Message(sender: sender, body: body, time: time, type: type))
                                
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
            self.toolbarBottomConstraint?.constant = keyboardFrame.size.height - 33
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
                self.toolbarBottomConstraint.constant = 0
                self.view.layoutIfNeeded()
            }, completion: nil)
        }
        else {
            self.toolbarBottomConstraint.constant = 0
            self.view.layoutIfNeeded()
        }
        
        textFieldDidChange(_sender: chattingTextField)
    }
}
