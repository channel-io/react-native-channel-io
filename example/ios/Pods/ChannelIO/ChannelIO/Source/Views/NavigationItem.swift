//
//  NavigationButton.swift
//  ch-desk-ios
//
//  Created by Haeun Chung on 15/05/2017.
//  Copyright © 2017 ZOYI. All rights reserved.
//

import Foundation
import UIKit

enum NavigationItemAlign {
  case left
  case right
  case center
}

class CHNavigationBar: UINavigationBar {
  override func layoutSubviews() {
    super.layoutSubviews()

    if #available(iOS 11, *){
      self.layoutMargins = UIEdgeInsets.zero
      for subview in self.subviews {
        if String(describing: subview.classForCoder).contains("ContentView") {
          //let oldEdges = subview.layoutMargins
          subview.layoutMargins = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        }
      }
    }
  }
}

class NavigationItem: UIBarButtonItem {
  public var actionHandler: (() -> Void)?
  
  convenience init(
    image: UIImage?,
    text: String? = "",
    fitToSize: Bool = false,
    alignment: NavigationItemAlign = .center,
    textColor: UIColor? = UIColor.white,
    actionHandler: (() -> Void)?) {
    
    let button = UIButton(type: .custom)
    button.setImage(image?.withRenderingMode(.alwaysTemplate), for: .normal)
    button.setTitle(text, for: .normal)
    button.imageView?.tintColor = textColor
    button.setTitleColor(textColor, for: .normal)
    if fitToSize {
      button.sizeToFit()
    }
    
    if alignment == .left {
      button.imageEdgeInsets = UIEdgeInsets(top: 0, left: -20, bottom: 0, right: 0)
      button.titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    } else if alignment == .right {
      button.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: -20)
      button.titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    } else {
      button.imageEdgeInsets = UIEdgeInsets(top: 0, left: -5, bottom: 0, right: 0)
      button.titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    button.widthAnchor.constraint(equalToConstant: 50).isActive = true
    button.heightAnchor.constraint(equalToConstant: 40).isActive = true
    button.translatesAutoresizingMaskIntoConstraints = false
    
    self.init(customView: button)
    button.addTarget(self, action: #selector(barButtonItemPressed), for: .touchUpInside)
    self.actionHandler = actionHandler
  }
  
  convenience init(
    title: String?,
    style: UIBarButtonItemStyle,
    textColor: UIColor = CHColors.defaultTint,
    actionHandler: (() -> Void)?) {
    
    self.init(title: title, style: style, target: nil, action: #selector(barButtonItemPressed))
    self.target = self
    self.actionHandler = actionHandler
    self.setTitleTextAttributes([NSAttributedStringKey.foregroundColor:textColor], for: .normal)
    
    let disableColor = textColor.withAlphaComponent(0.3)
    self.setTitleTextAttributes([NSAttributedStringKey.foregroundColor:disableColor], for: .disabled)
  }
  
  convenience init(
    image: UIImage?,
    style: UIBarButtonItemStyle,
    actionHandler: (() -> Void)?) {
    
    self.init(image: image, style: style, target: nil, action: #selector(barButtonItemPressed))
    self.target = self
    self.actionHandler = actionHandler
  }
  
  @objc func barButtonItemPressed(sender: UIBarButtonItem) {
    actionHandler?()
  }
}
