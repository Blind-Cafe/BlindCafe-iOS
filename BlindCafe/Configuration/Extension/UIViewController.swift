//
//  UIViewController.swift
//  BlindCafe
//
//  Created by 권하은 on 2021/10/27.
//

import UIKit
import SnapKit
import Lottie

extension UIViewController {
    // MARK: 빈 화면을 눌렀을 때 키보드가 내려가도록 처리
    func dismissKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer =
            UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
//        tap.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        self.view.endEditing(false)
    }
    
    // MARK: UIWindow의 rootViewController를 변경하여 화면전환
    func changeRootViewController(_ viewControllerToPresent: UIViewController) {
        if let window = UIApplication.shared.windows.first {
            window.rootViewController = viewControllerToPresent
            UIView.transition(with: window, duration: 0.5, options: .transitionCrossDissolve, animations: nil)
        } else {
            viewControllerToPresent.modalPresentationStyle = .overFullScreen
            self.present(viewControllerToPresent, animated: true, completion: nil)
        }
    }
    
    func presentAlert(message: String, target: ConstraintRelatableTarget? = nil, offset: Double? = -12) {
        let alertSuperview = UIView()
        alertSuperview.backgroundColor = .white
        alertSuperview.layer.cornerRadius = 5
        alertSuperview.isHidden = true
    
        let alertLabel = UILabel()
        //alertLabel.font = .NotoSans(.regular, size: 15)
        alertLabel.font = .systemFont(ofSize: 16, weight: .semibold)
        alertLabel.textColor = .darkGray
        
        self.view.addSubview(alertSuperview)
        alertSuperview.snp.makeConstraints { make in
            //make.bottom.equalTo(target ?? self.view.safeAreaLayoutGuide).offset(-12)
            make.centerY.equalToSuperview()
            make.centerX.equalToSuperview()
        }
        
        alertSuperview.addSubview(alertLabel)
        alertLabel.snp.makeConstraints { make in
            make.top.equalTo(18)
            make.bottom.equalTo(-18)
            make.leading.equalTo(18)
            make.trailing.equalTo(-18)
        }
        
        alertLabel.text = message
        alertSuperview.alpha = 1.0
        alertSuperview.isHidden = false
        UIView.animate(
            withDuration: 2.0,
            delay: 1.0,
            options: .curveEaseIn,
            animations: { alertSuperview.alpha = 0 },
            completion: { _ in
                alertSuperview.removeFromSuperview()
            }
        )
    }
    
    // MARK: 커스텀 하단 경고창
    func presentBottomAlert(name: String, target: ConstraintRelatableTarget? = nil, offset: Double? = -12) {
        let alertView = UIImageView(image: UIImage(named: name))
        alertView.isHidden = true
        
        self.view.addSubview(alertView)
        alertView.snp.makeConstraints { make in
            make.bottom.equalTo(target ?? self.view.safeAreaLayoutGuide).offset(-82)
            make.centerX.equalToSuperview()
        }
        
        alertView.alpha = 1.0
        alertView.isHidden = false
        UIImageView.animate(
            withDuration: 2.0,
            delay: 1.0,
            options: .curveEaseIn,
            animations: { alertView.alpha = 0 },
            completion: { _ in
                alertView.removeFromSuperview()
            }
        )
    }
    
    // MARK: 인디케이터 표시
    func showIndicator() {
        IndicatorView.shared.show()
        IndicatorView.shared.showIndicator()
    }
    
    // MARK: 인디케이터 숨김
    @objc func dismissIndicator() {
        IndicatorView.shared.dismiss()
    }
}
