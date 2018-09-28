//
//  ProfilePhoneView.swift
//  ChannelIO
//
//  Created by R3alFr3e on 4/11/18.
//  Copyright © 2018 ZOYI. All rights reserved.
//

import Foundation
import UIKit
import SnapKit

class ProfilePhoneView: ProfileItemBaseView, ProfileContentProtocol {
  let phoneView = PhoneActionView()
  var firstResponder: UIView {
    return self.phoneView.phoneField
  }
  var didFirstResponder: Bool {
    return self.phoneView.didFocus
  }
  
  override var fieldView: Actionable? {
    get {
      return self.phoneView
    }
  }
  
  override func initialize() {
    super.initialize()
    self.phoneView.setOutFocus()
  }
  
  override func setLayouts() {
    super.setLayouts()
  }
  
  override func configure(model: MessageCellModelType, index: Int?, presenter: ChatManager?) {
    super.configure(model: model, index: index, presenter: presenter)
    guard let item = self.item else { return }
    
    if let value = mainStore.state.guest.profile?[item.key] as? String {
      self.phoneView.setIntialValue(with: value)
    }
  }
}
