//
//  TextActionView.swift
//  CHPlugin
//
//  Created by Haeun Chung on 16/02/2017.
//  Copyright © 2017 ZOYI. All rights reserved.
//

import Foundation
import RxSwift
import SnapKit
import RxCocoa
import NVActivityIndicatorView

class TextActionView: BaseView, Actionable {
  let submitSubject = PublishSubject<Any?>()
  let focusSubject = PublishSubject<Bool>()
  
  let confirmButton = UIButton().then {
    $0.setImage(CHAssets.getImage(named: "sendActive")?.withRenderingMode(.alwaysOriginal), for: .normal)
    $0.setImage(CHAssets.getImage(named: "sendError")?.withRenderingMode(.alwaysOriginal), for: .disabled)
  }
  
  let loadIndicator = NVActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 22, height: 22)).then {
    $0.type = .circleStrokeSpin
    $0.color = CHColors.light
    $0.isHidden = true
  }
  
  let textField = UITextField().then {
    $0.font = UIFont.systemFont(ofSize: 18)
    $0.textColor = CHColors.dark
    $0.placeholder = CHAssets.localized("ch.profile_form.placeholder")
  }
  
  let disposeBeg = DisposeBag()
  var didFocus = false
  
  override func initialize() {
    super.initialize()
    
    self.layer.cornerRadius = 2.f
    self.layer.borderWidth = 1.f
    self.layer.borderColor = CHColors.paleGrey20.cgColor
    
    self.addSubview(self.confirmButton)
    self.addSubview(self.textField)
    self.addSubview(self.loadIndicator)
    
    NotificationCenter.default.rx
      .notification(Notification.Name.Channel.dismissKeyboard)
      .subscribe(onNext: { [weak self] (_) in
        self?.textField.resignFirstResponder()
      }).disposed(by: self.disposeBeg)
    
    self.textField.delegate = self
    self.textField.rx.text.subscribe(onNext: { [weak self] (text) in
      if let text = text {
        self?.confirmButton.isHidden = text.count == 0
      }
      self?.setFocus()
    }).disposed(by: self.disposeBeg)
    
    self.confirmButton.signalForClick()
      .subscribe(onNext: { [weak self] _ in
        self?.didFocus = true

        if let text = self?.textField.text, self?.textField.keyboardType == .decimalPad {
          let numberFormatter = NumberFormatter()
          numberFormatter.numberStyle = .decimal
          let value = numberFormatter.number(from: text)
          self?.submitSubject.onNext(value)
        } else {
          self?.submitSubject.onNext(self?.textField.text)
        }
        
      }).disposed(by: self.disposeBeg)
  }
  
  override func setLayouts() {
    super.setLayouts()
    
    self.textField.snp.makeConstraints { (make) in
      make.leading.equalToSuperview().inset(10)
      make.top.equalToSuperview()
      make.bottom.equalToSuperview()
    }
    
    self.confirmButton.snp.makeConstraints { [weak self] (make) in
      make.left.equalTo((self?.textField.snp.right)!)
      make.width.equalTo(44)
      make.height.equalTo(44)
      make.trailing.equalToSuperview()
      make.centerY.equalToSuperview()
    }
    
    self.loadIndicator.snp.makeConstraints { [weak self] (make) in
      make.centerX.equalTo((self?.confirmButton.snp.centerX)!)
      make.centerY.equalTo((self?.confirmButton.snp.centerY)!)
    }
  }
  
  //MARK: UserActionView Protocol
  
  func signalForAction() -> Observable<Any?> {
    return self.submitSubject.asObserver()
  }
  
  func signalForText() -> Observable<String?> {
    return self.textField.rx.text.asObservable()
  }
}

extension TextActionView {
  func setIntialValue(with value: String) {
    if let text = self.textField.text, text == "" {
      self.textField.text = value
    }
    self.confirmButton.isHidden = value == ""
  }
  
  func setLoading() {
    self.confirmButton.isHidden = true
    self.loadIndicator.isHidden = false
    self.loadIndicator.startAnimating()
  }
  
  func setFocus() {
    self.layer.borderColor = CHColors.brightSkyBlue.cgColor
    self.confirmButton.isEnabled = true
    self.focusSubject.onNext(true)
  }
  
  func setOutFocus() {
    self.layer.borderColor = CHColors.paleGrey20.cgColor
    self.focusSubject.onNext(false)
  }
  
  func setInvalid() {
    self.layer.borderColor = CHColors.yellowishOrange.cgColor
    self.confirmButton.isEnabled = false
    self.confirmButton.isHidden = false
    self.loadIndicator.isHidden = true
  }
  
  func signalForFocus() -> Observable<Bool> {
    return self.focusSubject
  }
}

extension TextActionView: UITextFieldDelegate {
  func textFieldDidBeginEditing(_ textField: UITextField) {
    if self.textField == textField {
      self.didFocus = true
      self.setFocus()
    } else {
      self.setOutFocus()
    }
  }
  
  func textFieldDidEndEditing(_ textField: UITextField) {
    self.setOutFocus()
  }
  
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    self.didFocus = true
    self.submitSubject.onNext(textField.text)
    return false
  }
}
