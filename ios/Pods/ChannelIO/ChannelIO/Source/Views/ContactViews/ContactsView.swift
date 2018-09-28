//
//  ContactsView.swift
//  CHPlugin
//
//  Created by Haeun Chung on 29/11/2017.
//  Copyright © 2017 ZOYI. All rights reserved.
//

import UIKit

class ContactsView : BaseView {
  var buttons = [ContactComponentButton]()
  
  var buttonSize: CGFloat = 0
  
  override func initialize() {
    super.initialize()
  }
  
  override func setLayouts() {
    super.setLayouts()
  }
  
  func addButton(baseColor: UIColor, image: UIImage?, action: (() -> Void)? = nil) {
    guard let image = image else { return }
    guard let action = action else { return }
    
    let button = ContactComponentButton(
      image: image.withRenderingMode(.alwaysTemplate),
      action: action)
    
    button.setBackgroundColorsWith(baseColor: baseColor)
    button.tintColor = baseColor
    button.layer.cornerRadius = self.buttonSize/2
    
    self.buttons.append(button)
    self.addSubview(button)

  }

  func remove(at index: Int) {
    guard index < 0 || index > self.buttons.count - 1 else { return }
    let removed = self.buttons.remove(at: index)
    removed.removeFromSuperview()
  }
  
  func removeAllButtons() {
    self.buttons.removeAll()
    for view in self.subviews {
      view.removeFromSuperview()
    }
  }
  
  func layoutButtons() {
    guard self.buttons.count > 0 else { return }
    
    var lastButton: UIView? = nil
    for (index, button) in self.buttons.enumerated() {
      button.snp.remakeConstraints({ [weak self] (make) in
        guard let s = self else { return }
        if lastButton == nil {
          make.leading.equalToSuperview()
        } else {
          make.leading.equalTo((lastButton?.snp.trailing)!).offset(14)
        }
        
        if index == s.buttons.count - 1 {
          make.trailing.equalToSuperview()
        }
        
        make.top.equalToSuperview()
        make.bottom.equalToSuperview()
        make.height.equalTo(s.buttonSize)
        make.width.equalTo(s.buttonSize)
      })
      
      lastButton = button
    }
  }
}
