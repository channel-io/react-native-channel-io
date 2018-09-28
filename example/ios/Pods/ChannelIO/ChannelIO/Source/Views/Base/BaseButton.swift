//
//  BaseButton.swift
//  CHPlugin
//
//  Created by 이수완 on 2017. 3. 23..
//  Copyright © 2017년 ZOYI. All rights reserved.
//

import UIKit

class BaseButton: UIButton {

  // MARK: Initializing

  override init(frame: CGRect) {
    super.init(frame: frame)
    self.initialize()
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  func initialize() {
    // Override point
  }
}
