//
//  TextField.swift
//  CHPlugin
//
//  Created by Haeun Chung on 19/05/2017.
//  Copyright © 2017 ZOYI. All rights reserved.
//

import Foundation
import SnapKit
import RxSwift

protocol CHFieldProtocol {
  var field: UITextField { get }
  func getText() -> String
  func setText(_ value: String)
  func isValid() -> Observable<Bool>
}

final class CHTextField : BaseView {
  let topDivider = UIView().then {
    $0.backgroundColor = CHColors.darkTwo
  }
  
  let field = UITextField().then {
    $0.font = UIFont.systemFont(ofSize: 17)
    $0.clearButtonMode = .whileEditing
    $0.textColor = CHColors.dark
  }
  
  let botDivider = UIView().then {
    $0.backgroundColor = CHColors.darkTwo
  }
  
  let validSubject = PublishSubject<Bool>()
  
  convenience init(text: String = "", placeholder: String) {
    self.init(frame: CGRect.zero)
    self.field.text = text
    self.field.placeholder = placeholder
  }
  
  override func initialize() {
    super.initialize()
    
    self.field.addTarget(
      self,
      action: #selector(textFieldDidChange(_:)),
      for: .editingChanged)
    
    self.backgroundColor = UIColor.white
    
    self.addSubview(self.field)
    self.addSubview(self.topDivider)
    self.addSubview(self.botDivider)
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    
    self.topDivider.snp.remakeConstraints { (make) in
      make.leading.equalToSuperview()
      make.trailing.equalToSuperview()
      make.top.equalToSuperview()
      make.height.equalTo(1)
    }
    
    self.field.snp.remakeConstraints { (make) in
      make.leading.equalToSuperview().inset(20)
      make.trailing.equalToSuperview().inset(20)
      make.top.equalToSuperview()
      make.bottom.equalToSuperview()
    }
    
    self.botDivider.snp.remakeConstraints { (make) in
      make.leading.equalToSuperview()
      make.trailing.equalToSuperview()
      make.bottom.equalToSuperview()
      make.height.equalTo(1)
    }
  }
}

extension CHTextField: CHFieldProtocol {

  func getText() -> String {
    return self.field.text ?? ""
  }
  
  func setText(_ value: String) {
    //self.textField.text = value
  }
  
  func isValid() -> Observable<Bool> {
    return self.validSubject
  }
  
  @objc func textFieldDidChange(_ textField: UITextField) {
    self.validSubject.onNext(true)
  }
  
}

