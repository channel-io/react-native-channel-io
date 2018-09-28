//
//  ProfileTextView.swift
//  ChannelIO
//
//  Created by R3alFr3e on 4/11/18.
//  Copyright © 2018 ZOYI. All rights reserved.
//

import Foundation
import UIKit
import SnapKit


class ProfileTextView: ProfileItemBaseView, ProfileContentProtocol {
  let textView = TextActionView()
  var firstResponder: UIView {
    return self.textView.textField
  }
  var didFirstResponder: Bool {
    return self.textView.didFocus
  }
  override var fieldType: ProfileInputType {
    didSet {
      if self.fieldType == .number {
        self.textView.textField.keyboardType = .decimalPad
      } else {
        self.textView.textField.keyboardType = .default
      }
    }
  }
  
  override var fieldView: Actionable? {
    get {
      return self.textView
    }
  }
  
  override func initialize() {
    super.initialize()
    self.textView.setOutFocus()
  }
  
  override func setLayouts() {
    super.setLayouts()
  }
  
  override func configure(model: MessageCellModelType, index: Int?, presenter: ChatManager?) {
    super.configure(model: model, index: index, presenter: presenter)
    guard let item = self.item else { return }
    
    if let value = mainStore.state.guest.profile?[item.key] {
      self.textView.setIntialValue(with: "\(value)")
    }
  }
}
