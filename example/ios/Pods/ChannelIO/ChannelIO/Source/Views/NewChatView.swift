//
//  NewChatView.swift
//  CHPlugin
//
//  Created by Haeun Chung on 14/02/2017.
//  Copyright © 2017 ZOYI. All rights reserved.
//

import Foundation
import RxSwift
import ReSwift
import SnapKit

class NewChatView : BaseButton {

  // MARK: Constant
  
  struct Constant {
    static let viewSize = 54.f
  }
  
  struct Metric {
    static var xMargin = 24.f
    static var yMargin = 24.f
  }

  override func initialize() {
    super.initialize()

    self.layer.shadowColor = UIColor.black.cgColor
    self.layer.shadowOpacity = 0.3
    self.layer.shadowOffset = CGSize(width: 0, height: 4)
    self.layer.shadowRadius = 5
    self.layer.cornerRadius = Constant.viewSize / 2.f
    self.layer.borderWidth = 1

    self.setImage(CHAssets.getImage(named: "plus")?.withRenderingMode(.alwaysTemplate), for: .normal)
  }
  
  func configure(bgColor: String, borderColor: String, tintColor: String) {
    self.backgroundColor = UIColor(bgColor)
    self.layer.borderColor = UIColor(borderColor)?.cgColor
    self.imageView?.tintColor = tintColor == "white" ? UIColor.white : UIColor.black
  }
  
  override func updateConstraints() {
    self.snp.makeConstraints({ (make) in
      make.size.equalTo(CGSize(width:Constant.viewSize, height:Constant.viewSize))
    })
    super.updateConstraints()
  }
}
