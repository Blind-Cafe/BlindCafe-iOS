//
//  UserDelete2ViewController.swift
//  BlindCafe
//
//  Created by 권하은 on 2021/11/24.
//

import UIKit

class UserDelete2ViewController: UIViewController {
    
    var id : Int = 0

    @IBAction func dismissButton(_ sender: Any) {
        dismiss(animated: false, completion: nil)
    }
    
    @IBAction func userDeleteButton(_ sender: Any) {
        showIndicator()
        UserDeleteDataManager().delete(id: id, viewController: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

}

extension UserDelete2ViewController {
    func deleted(){
        dismissIndicator()
        let vc = LastViewController()
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true, completion: nil)
    }
    func failedToRequest(message: String) {
        dismissIndicator()
        presentAlert(message: message)
    }
}
