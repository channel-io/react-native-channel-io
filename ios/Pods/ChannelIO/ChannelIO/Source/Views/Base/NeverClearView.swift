//
//  NeverClearView.swift
//  CHPlugin
//
//  Created by 이수완 on 2017. 3. 2..
//  Copyright © 2017년 ZOYI. All rights reserved.
//

import UIKit

class NeverClearView: BaseView {
  override var backgroundColor: UIColor? {
    didSet {
      if self.backgroundColor?.cgColor.alpha == 0 {
        backgroundColor = oldValue
      }
    }
  }
}
