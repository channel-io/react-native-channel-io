//
//  PhoneActionView.swift
//  CHPlugin
//
//  Created by Haeun Chung on 16/02/2017.
//  Copyright © 2017 ZOYI. All rights reserved.
//

import Foundation
import RxSwift
import SnapKit
import PhoneNumberKit
import NVActivityIndicatorView

final class PhoneActionView: BaseView, Actionable {
  //MARK: Constants
  struct Constants {
    static let defaultDailCode = "+82"
  }
  
  struct Metric {
    static let countryLabelLeading = 16.f
    static let arrowImageLeading = 3.f
    static let arrowImageTrailing = 3.f
    static let phoneFieldLeading = 10.f
    static let confirmButtonWidth = 75.f
    static let arrowImageSize = CGSize(width: 9, height: 8)
  }

  //MARK: Properties
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
  
  let countryCodeView = UIView()
  let countryLabel = UILabel().then {
    $0.font = UIFont.systemFont(ofSize: 18)
    $0.textColor = CHColors.dark
    $0.textAlignment = .center
    $0.text = ""
  }
  
  let arrowDownView = UIImageView().then {
    $0.contentMode = UIViewContentMode.center
    $0.image = CHAssets.getImage(named: "dropdownTriangle")
  }
  
  let phoneField = PhoneNumberTextField().then {
    $0.keyboardType = .phonePad
    $0.placeholder = CHAssets.localized("ch.profile_form.placeholder")
  }
  
  var didFocus = false
  var userGeoInfo: GeoIPInfo?
  var currentCountryCode: String = ""
  
  let disposeBeg = DisposeBag()
  //MARK: Init
  
  override func initialize() {
    super.initialize()
    
    self.layer.cornerRadius = 2.f
    self.layer.borderWidth = 1.f
    self.layer.borderColor = CHColors.paleGrey20.cgColor
    
    self.addSubview(self.phoneField)
    self.addSubview(self.confirmButton)
    self.addSubview(self.loadIndicator)
    self.addSubview(self.countryCodeView)
    self.countryCodeView.addSubview(self.countryLabel)
    self.countryCodeView.addSubview(self.arrowDownView)
    
    if self.didFocus {
      self.phoneField.becomeFirstResponder()
    }
    
    NotificationCenter.default.rx
      .notification(Notification.Name.Channel.dismissKeyboard)
      .subscribe(onNext: { [weak self] (_) in
        self?.phoneField.resignFirstResponder()
      }).disposed(by: self.disposeBeg)
    
    self.phoneField.delegate = self
    self.phoneField.rx.text.subscribe(onNext: { [weak self] (text) in
      if let text = text {
        self?.confirmButton.isHidden = text.count == 0
      }
      self?.setFocus()
    }).disposed(by: self.disposeBeg)
    
    UtilityPromise.getCountryCodes().observeOn(MainScheduler.instance)
      .flatMap { (countries) -> Observable<GeoIPInfo> in
        mainStore.dispatch(GetCountryCodes(payload: countries))
        return UtilityPromise.getGeoIP()
      }.subscribe(onNext: { [weak self] (geoInfo) in
        if let countryCode = CHUtils.getCountryDialCode(countryCode: geoInfo.country),
          let text = self?.countryLabel.text, text == "" {
          self?.countryLabel.text = "+" + countryCode
        }
        self?.phoneField.defaultRegion = geoInfo.country
        self?.currentCountryCode = geoInfo.country
      }, onError: { [weak self] (error) in
        self?.countryLabel.text = Constants.defaultDailCode
      }).disposed(by: self.disposeBeg)

    self.countryCodeView.signalForClick().subscribe(onNext: { [weak self] (value) in
      let firstResponder = UIResponder.slk_currentFirst()
      UIApplication.shared.sendAction(#selector(UIApplication.resignFirstResponder), to: nil, from: nil, for: nil)
      let code = self?.currentCountryCode ?? ""
        
      CountryCodePickerView.presentCodePicker(with: code)
        .subscribe(onNext: { (code, dial) in
          if let dial = dial {
            self?.countryLabel.text =  "+" + dial
          }
          if firstResponder == self?.phoneField {
            self?.phoneField.becomeFirstResponder()
          }
          if let code = code {
            self?.currentCountryCode = code
            self?.phoneField.defaultRegion = code
          }
          
        }).disposed(by: (self?.disposeBeg)!)
      }).disposed(by: self.disposeBeg)
    
    self.confirmButton.signalForClick().subscribe(onNext: { [weak self] _ in
      self?.submitValue()
    }).disposed(by: self.disposeBeg)
  }

  override func setLayouts() {
    super.setLayouts()
    
    self.countryCodeView.snp.makeConstraints { (make) in
      make.width.equalTo(70).priority(750)
      make.top.equalToSuperview()
      make.bottom.equalToSuperview()
      make.leading.equalToSuperview()
    }
    
    self.countryLabel.snp.makeConstraints { (make) in
      make.leading.equalToSuperview().inset(10)
      make.centerY.equalToSuperview()
    }
    
    self.arrowDownView.snp.makeConstraints { [weak self] (make) in
      make.size.equalTo(Metric.arrowImageSize)
      make.left.equalTo((self?.countryLabel.snp.right)!).offset(Metric.arrowImageLeading)
      make.centerY.equalToSuperview()
      make.trailing.equalToSuperview().inset(Metric.arrowImageTrailing)
    }
    
    self.phoneField.snp.makeConstraints { [weak self] (make) in
      make.left.equalTo((self?.countryCodeView.snp.right)!).offset(Metric.phoneFieldLeading)
      make.right.equalTo((self?.confirmButton.snp.left)!)
      make.top.equalToSuperview()
      make.bottom.equalToSuperview()
    }
    
    self.confirmButton.snp.makeConstraints { (make) in
      make.width.equalTo(44)
      make.trailing.equalToSuperview()
      make.top.equalToSuperview()
      make.bottom.equalToSuperview()
    }
    
    self.loadIndicator.snp.makeConstraints { [weak self] (make) in
      make.centerY.equalTo((self?.confirmButton.snp.centerY)!)
      make.centerX.equalTo((self?.confirmButton.snp.centerX)!)
    }
  }
}

extension PhoneActionView {
  func setIntialValue(with value: String) {
    if let text = self.phoneField.text, text == "" {
      do {
        let phKit = PhoneNumberKit()
        let phoneNumber = try phKit.parse(value)
        
        self.countryLabel.text = "+\(phoneNumber.countryCode)"
        self.phoneField.text = "\(phoneNumber.nationalNumber)"
      }
      catch {
        print("Generic parser error")
      }
      
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
  
  func submitValue() {
    if let code = self.countryLabel.text, let number = self.phoneField.text {
      let fullNumber = code + "-" + number
      self.submitSubject.onNext(fullNumber)
    }
  }
  
  func signalForAction() -> Observable<Any?> {
    return self.submitSubject.asObserver()
  }
  
  func signalForText() -> Observable<String?> {
    return self.phoneField.rx.text.asObservable()
  }
  
  func signalForFocus() -> Observable<Bool> {
    return self.focusSubject
  }
}

extension PhoneActionView: UITextFieldDelegate {
  func textFieldDidBeginEditing(_ textField: UITextField) {
    if self.phoneField == textField {
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
    self.submitValue()
    return false
  }
}

