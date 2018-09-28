//
//  CompleteActionView.swift
//  ChannelIO
//
//  Created by R3alFr3e on 4/18/18.
//  Copyright © 2018 ZOYI. All rights reserved.
//

import Foundation
import RxSwift

class CompleteActionView: BaseView, Actionable {
  let submitSubject = PublishSubject<Any?>()
  let textSubject = PublishSubject<String?>()
  
  let contentLabel = UILabel().then {
    $0.font = UIFont.systemFont(ofSize: 18)
    $0.textColor = CHColors.dark
  }
  
  let completionImageView = UIImageView().then {
    $0.image = CHAssets.getImage(named: "complete")
  }
  var didFocus: Bool = false
  
  override func initialize() {
    super.initialize()
    
    self.addSubview(self.contentLabel)
    self.addSubview(self.completionImageView)
  }
  
  override func setLayouts() {
    super.setLayouts()
    
    self.contentLabel.snp.makeConstraints { (make) in
      make.left.equalToSuperview()
      make.centerY.equalToSuperview()
    }
    
    self.completionImageView.snp.makeConstraints { [weak self] (make) in
      make.left.greaterThanOrEqualTo((self?.contentLabel.snp.right)!).offset(14)
      make.right.equalToSuperview()
      make.centerY.equalToSuperview()
      make.height.equalTo(24)
      make.width.equalTo(24)
    }
  }
  
  func signalForText() -> Observable<String?> {
    return self.textSubject.asObserver()
  }
  
  func signalForAction() -> Observable<Any?> {
    return self.submitSubject.asObserver()
  }
  
  func setLoading() {}
  func setFocus() {}
  func setOutFocus() {}
  func setInvalid() {}
  func signalForFocus() -> Observable<Bool> {
    return Observable.just(false);
  }
}
