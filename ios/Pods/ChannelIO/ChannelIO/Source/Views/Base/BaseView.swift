//
//  BaseView.swift
//  CHPlugin
//
//  Created by 이수완 on 2017. 2. 6..
//  Copyright © 2017년 ZOYI. All rights reserved.
//

import UIKit

class BaseView: UIView {

  // MARK: Initializing
  override init(frame: CGRect) {
    super.init(frame: frame)
    self.initialize()
    self.setLayouts()
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  func initialize() {
    // Override point
  }
  
  func setLayouts() {
    // Override 
  }
}
