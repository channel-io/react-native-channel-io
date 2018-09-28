//
//  PhoneField.swift
//  CHPlugin
//
//  Created by Haeun Chung on 18/05/2017.
//  Copyright © 2017 ZOYI. All rights reserved.
//

import Foundation
import PhoneNumberKit
import SnapKit
import RxSwift

final class CHPhoneField: BaseView {

  fileprivate var code : String = "82"
  fileprivate var number : String = ""
  
  struct Constants {
    static let defaultDailCode = "82"
  }
  
  struct Metric {
    static let countryLabelLeading = 16.f
    static let arrowImageLeading = 9.f
    static let arrowImageTrailing = 3.f
    static let phoneFieldLeading = 10.f
    static let arrowImageSize = CGSize(width: 9, height: 8)
  }

  let validSubject = PublishSubject<Bool>()
  
  var disposeBeg = DisposeBag()
  let countryCodeView = UIView()
  let countryLabel = UILabel().then {
    $0.font = UIFont.systemFont(ofSize: 18)
    $0.textColor = CHColors.dark
    $0.text = "+" + Constants.defaultDailCode
  }
  
  let arrowDownView = UIImageView().then {
    $0.contentMode = UIViewContentMode.center
    $0.image = CHAssets.getImage(named: "dropdownTriangle")
  }
  
  let topDivider = UIView().then {
    $0.backgroundColor = CHColors.darkTwo
  }
  
  let field = UITextField().then {
    $0.keyboardType = .phonePad
    $0.clearButtonMode = .whileEditing
    $0.placeholder = CHAssets.localized("ch.settings.edit.phone_number_placeholder")
  }
  
  let bottomDivider = UIView().then {
    $0.backgroundColor = CHColors.darkTwo
  }
  
  convenience init(text: String = "") {
    self.init(frame: CGRect.zero)
    
    do {
      let phKit = PhoneNumberKit()
      let phoneNumber = try phKit.parse(text)
      self.number = "\(phoneNumber.nationalNumber)"
      self.code = "\(phoneNumber.countryCode)"
    } catch {
      self.number = text
    }
    
    self.field.text = self.number
    self.countryLabel.text = "+" + self.code
  }
  
  override func initialize(){
    super.initialize()
    self.handleAction()
    
    self.field.addTarget(
      self,
      action: #selector(textFieldDidChange(_:)),
      for: .editingChanged)
    
    self.backgroundColor = CHColors.white
    
    self.countryCodeView.addSubview(self.countryLabel)
    self.countryCodeView.addSubview(self.arrowDownView)
    self.addSubview(self.countryCodeView)
    self.addSubview(self.field)
    self.addSubview(self.topDivider)
    self.addSubview(self.bottomDivider)
  }
  
  override func layoutSubviews(){
    super.layoutSubviews()
    
    self.countryCodeView.snp.makeConstraints { (make) in
      make.width.lessThanOrEqualTo(90)
      make.top.equalToSuperview()
      make.bottom.equalToSuperview()
      make.leading.equalToSuperview()
    }
    
    self.countryLabel.snp.makeConstraints { (make) in
      make.leading.equalToSuperview().inset(Metric.countryLabelLeading)
      make.centerY.equalToSuperview()
    }
    
    self.arrowDownView.snp.makeConstraints { [weak self] (make) in
      make.size.equalTo(Metric.arrowImageSize)
      make.left.equalTo((self?.countryLabel.snp.right)!).offset(Metric.arrowImageLeading)
      make.centerY.equalToSuperview()
      make.trailing.equalToSuperview().inset(Metric.arrowImageTrailing)
    }
    
    self.topDivider.snp.makeConstraints { (make) in
      make.top.equalToSuperview()
      make.leading.equalToSuperview()
      make.trailing.equalToSuperview()
      make.height.equalTo(1)
    }
    
    self.field.snp.makeConstraints { [weak self] (make) in
      make.left.equalTo((self?.countryCodeView.snp.right)!).offset(Metric.phoneFieldLeading)
      make.trailing.equalToSuperview()
      make.top.equalToSuperview()
      make.bottom.equalToSuperview()
    }
    
    self.bottomDivider.snp.makeConstraints { (make) in
      make.leading.equalToSuperview()
      make.trailing.equalToSuperview()
      make.height.equalTo(1)
      make.bottom.equalToSuperview()
    }
  }
}

extension CHPhoneField : CHFieldProtocol {
  func getText() -> String {
    if let number = self.field.text,
      number == "" {
      return ""
    }
    
    return "+" + self.code + (self.field.text ?? "")
  }
  
  func setText(_ value: String) {
    //
  }
  
  func isValid() -> Observable<Bool> {
    return self.validSubject
  }
  
  @objc func textFieldDidChange(_ textField: UITextField) {
    //phone number validation
    self.validSubject.onNext(true)
  }
}

extension CHPhoneField {
  func handleAction() {
    
    self.countryCodeView.signalForClick()
      .subscribe(onNext: { [weak self] (_) in
        self?.field.resignFirstResponder()
        
        var controller = CHUtils.getTopController()
        if let navigation = controller?.navigationController {
          controller = navigation
        }
        
        let pickerView = CountryCodePickerView(frame: (controller?.view.frame)!)
        var code = (self?.countryLabel.text ?? "")
        code.remove(at: code.startIndex)
        
        pickerView.pickedCode = code
        pickerView.showPicker(onView: (controller?.view)!,animated: true)
        
        pickerView.signalForSubmit()
          .subscribe(onNext: { (name, code) in
            self?.code = code
            self?.countryLabel.text =  "+" + code
          }).disposed(by: (self?.disposeBeg)!)
    }).disposed(by: self.disposeBeg)
  }

}


